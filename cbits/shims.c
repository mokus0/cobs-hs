#include <cobs.h>
#include <cobsr.h>

size_t cobs_encode_dst_buf_len_max(size_t src_len) {
    if (src_len == 0) return 1;
    return COBS_ENCODE_DST_BUF_LEN_MAX(src_len);
}

uint8_t cobs_encode_shim(uint8_t *dst_buf_ptr, size_t *dst_buf_len, const uint8_t * src_ptr, size_t src_len) {
    cobs_encode_result result = cobs_encode(dst_buf_ptr, *dst_buf_len, src_ptr, src_len);
    *dst_buf_len = result.out_len;
    return result.status;
}

size_t cobs_decode_dst_buf_len_max(size_t src_len) {
    return COBS_DECODE_DST_BUF_LEN_MAX(src_len);
}

uint8_t cobs_decode_shim(uint8_t *dst_buf_ptr, size_t *dst_buf_len, const uint8_t * src_ptr, size_t src_len) {
    cobs_decode_result result = cobs_decode(dst_buf_ptr, *dst_buf_len, src_ptr, src_len);
    *dst_buf_len = result.out_len;
    return result.status;
}


size_t cobsr_encode_dst_buf_len_max(size_t src_len) {
    if (src_len == 0) return 1;
    return COBSR_ENCODE_DST_BUF_LEN_MAX(src_len);
}

uint8_t cobsr_encode_shim(uint8_t *dst_buf_ptr, size_t *dst_buf_len, const uint8_t * src_ptr, size_t src_len) {
    cobsr_encode_result result = cobsr_encode(dst_buf_ptr, *dst_buf_len, src_ptr, src_len);
    *dst_buf_len = result.out_len;
    return result.status;
}

size_t cobsr_decode_dst_buf_len_max(size_t src_len) {
    return COBSR_DECODE_DST_BUF_LEN_MAX(src_len);
}

uint8_t cobsr_decode_shim(uint8_t *dst_buf_ptr, size_t *dst_buf_len, const uint8_t * src_ptr, size_t src_len) {
    cobsr_decode_result result = cobsr_decode(dst_buf_ptr, *dst_buf_len, src_ptr, src_len);
    *dst_buf_len = result.out_len;
    return result.status;
}

