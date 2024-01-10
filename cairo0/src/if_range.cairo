%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.math_cmp import (
    is_not_zero,
    is_nn,
    is_le,
    is_nn_le,
    is_in_range,
    is_le_felt,
)
from starkware.cairo.common.bool import TRUE, FALSE

from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_le,
    uint256_lt,
    uint256_check,
    uint256_eq,
    uint256_sqrt,
    uint256_unsigned_div_rem,
)


@external
func check_quarter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(number: felt) -> (quarter: felt) {
    alloc_locals;
    local quarter;

    let data = is_le(number,3);

    if (data == TRUE){
        assert quarter = 1;
    } else {
        if (is_le(number,7) == TRUE){
            assert quarter = 2;
        } else {
            if (is_le(number,12) == TRUE){
                assert quarter = 3;
            } else {
                assert quarter = 4;
            }
        }
    }
    return (quarter= quarter);
}