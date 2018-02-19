{-# LANGUAGE ForeignFunctionInterface #-}
module Codec.COBS
    ( cobsEncode, cobsDecode
    , cobsrEncode, cobsrDecode
    ) where

import Control.Exception
import Control.Monad
import qualified Data.ByteString as BS
import qualified Data.ByteString.Unsafe as BS
import Data.Word
import Foreign.C.Types
import Foreign.Marshal
import Foreign.Ptr
import Foreign.Storable
import System.IO.Unsafe (unsafePerformIO)

newtype CobsException = CobsException Word8
    deriving (Eq, Ord, Read, Show)

instance Exception CobsException

wrap :: (CSize -> IO CSize)
    -> (Ptr Word8 -> Ptr CSize -> Ptr Word8 -> CSize -> IO Word8)
    -> BS.ByteString -> BS.ByteString
wrap getMaxLen shim src = unsafePerformIO $ do
    max_len <- getMaxLen (fromIntegral (BS.length src))
    dst <- mallocBytes (fromIntegral max_len)
    BS.useAsCStringLen src $ \(src, src_len) -> do
        with max_len $ \dst_len -> do
            status <- shim (castPtr dst) dst_len (castPtr src) (fromIntegral src_len)
            when (status /= 0) $ do
                print (dst, dst_len, src, src_len)
                throwIO (CobsException status)
            
            len <- peek dst_len
            BS.unsafePackMallocCStringLen (dst, fromIntegral len)

foreign import ccall cobs_encode_dst_buf_len_max :: CSize -> IO CSize
foreign import ccall cobs_encode_shim :: Ptr Word8 -> Ptr CSize -> Ptr Word8 -> CSize -> IO Word8
cobsEncode :: BS.ByteString -> BS.ByteString
cobsEncode = wrap cobs_encode_dst_buf_len_max cobs_encode_shim

foreign import ccall cobs_decode_dst_buf_len_max :: CSize -> IO CSize
foreign import ccall cobs_decode_shim :: Ptr Word8 -> Ptr CSize -> Ptr Word8 -> CSize -> IO Word8
cobsDecode :: BS.ByteString -> BS.ByteString
cobsDecode = wrap cobs_decode_dst_buf_len_max cobs_decode_shim

foreign import ccall cobsr_encode_dst_buf_len_max :: CSize -> IO CSize
foreign import ccall cobsr_encode_shim :: Ptr Word8 -> Ptr CSize -> Ptr Word8 -> CSize -> IO Word8
cobsrEncode :: BS.ByteString -> BS.ByteString
cobsrEncode = wrap cobsr_encode_dst_buf_len_max cobsr_encode_shim

foreign import ccall cobsr_decode_dst_buf_len_max :: CSize -> IO CSize
foreign import ccall cobsr_decode_shim :: Ptr Word8 -> Ptr CSize -> Ptr Word8 -> CSize -> IO Word8
cobsrDecode :: BS.ByteString -> BS.ByteString
cobsrDecode = wrap cobsr_decode_dst_buf_len_max cobsr_decode_shim
