use core::array::SpanTrait;
use cairo1::helpers::{bit_length, all_ones, shl};


use core::ArrayTrait;


fn height(index: u64) -> u64 {
    assert(index >= 1, 'Out of bound');

    let bits = bit_length(index);
    let ones = all_ones(bits);
    if (index != ones) {
        let shifted = shl(1, bits - 1);
        let rec_height = height(index - (shifted - 1));

        return rec_height;
    }

    return bits - 1;
}
