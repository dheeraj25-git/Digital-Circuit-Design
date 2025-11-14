1. 8×8 dual-clock FIFO (100 MHz write, 50 MHz read)
2. Gray code pointers + 2-stage synchronizers to prevent metastability
3. Full/empty flags with wraparound detection (4-bit pointers)
4. Verified: Full at 8th write, empty after 60 ns sync delay
5. 100% data integrity across clock domains
