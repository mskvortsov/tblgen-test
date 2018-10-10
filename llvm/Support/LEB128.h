/// Utility function to decode a ULEB128 value.
inline uint64_t decodeULEB128(const uint8_t *p, unsigned *n = nullptr,
                              const uint8_t *end = nullptr,
                              const char **error = nullptr) {
  const uint8_t *orig_p = p;
  uint64_t Value = 0;
  unsigned Shift = 0;
  if (error)
    *error = nullptr;
  do {
    if (end && p == end) {
      if (error)
        *error = "malformed uleb128, extends past end";
      if (n)
        *n = (unsigned)(p - orig_p);
      return 0;
    }
    uint64_t Slice = *p & 0x7f;
    if (Shift >= 64 || Slice << Shift >> Shift != Slice) {
      if (error)
        *error = "uleb128 too big for uint64";
      if (n)
        *n = (unsigned)(p - orig_p);
      return 0;
    }
    Value += uint64_t(*p & 0x7f) << Shift;
    Shift += 7;
  } while (*p++ >= 128);
  if (n)
    *n = (unsigned)(p - orig_p);
  return Value;
}
