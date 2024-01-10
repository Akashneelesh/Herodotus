use alexandria_math::pow;
use integer::{u64_wide_mul, BoundedInt};

fn bit_length(num: u64) -> u64 {
    assert(num > 0, 'Incorect');
    return bit_length_rec(num, 0);
}

fn bit_length_rec(num: u64, current_length: u64) -> u64 {
    let max = pow(2, current_length);
    let is_smaller = if (num < max - 1) {
        true
    } else {
        false
    };

    if (is_smaller == true) {
        return current_length;
    }

    return bit_length_rec(num, current_length + 1);
}


fn all_ones(bit_length: u64) -> u64 {
    assert(bit_length > 0, 'Incorect');
    let max = pow(2, bit_length);
    max - 1
}

fn shl(x: u64, n: u64) -> u64 {
    (u64_wide_mul(x, pow(2, n)) & BoundedInt::<u64>::max().into()).try_into().unwrap()
}

fn shr(x: u64, n: u64) -> u64 {
    x / pow(2, n)
}
