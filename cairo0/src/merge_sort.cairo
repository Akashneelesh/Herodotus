%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.bool import TRUE, FALSE

struct Array {
    value : felt,
}

func mergesort_elements{range_check_ptr}(array_len: felt, felt_array: Array*) -> (
    sorted_entries_ptr: Array*
) {
    alloc_locals;

    // If the array len is 1 it directly returns the array
    if (array_len == 1) {
        return (felt_array,);
    }

    let (left_array_len, _) = unsigned_div_rem(array_len, 2);
    let right_array_len = array_len - left_array_len;

  
    let left_array = felt_array;
    // pointer in terms of memory units
    let right_array = felt_array + left_array_len * Array.SIZE;

    let (sorted_left_array) = mergesort_elements(left_array_len, left_array);
    let (sorted_right_array) = mergesort_elements(right_array_len, right_array);
    let (result_array: Array*) = alloc();

    let (sorted_array) = _merge(
        left_array_len, sorted_left_array, right_array_len, sorted_right_array, result_array, 0, 0, 0
    );
    return (sorted_array,);
}

func _merge{range_check_ptr}(
    left_array_len: felt,
    left_array: Array*,
    right_array_len: felt,
    right_array: Array*,
    sorted_array: Array*,
    current_index: felt,
    left_array_index: felt,
    right_array_index: felt,
) -> (sorted_array: Array*) {
    alloc_locals;

    if ((current_index) == (left_array_len + right_array_len)) {
        return (sorted_array,);
    }

    if (left_array_len == left_array_index) {
        assert sorted_array[current_index] = right_array[right_array_index];
        return _merge(
            left_array_len,
            left_array,
            right_array_len,
            right_array,
            sorted_array,
            current_index + 1,
            left_array_index,
            right_array_index + 1,
        );
    }

    if (right_array_len == right_array_index) {
        assert sorted_array[current_index] = left_array[left_array_index];
        return _merge(
            left_array_len,
            left_array,
            right_array_len,
            right_array,
            sorted_array,
            current_index + 1,
            left_array_index + 1,
            right_array_index,
        );
    }

    let left_val = left_array[left_array_index].value;
    let right_val = right_array[right_array_index].value;
    let is_left = is_le(left_val, right_val);

    if (is_left == 1) {
        assert sorted_array[current_index] = left_array[left_array_index];
        return _merge(
            left_array_len,
            left_array,
            right_array_len,
            right_array,
            sorted_array,
            current_index + 1,
            left_array_index + 1,
            right_array_index,
        );
    } else {
        assert sorted_array[current_index] = right_array[right_array_index];
        return _merge(
            left_array_len,
            left_array,
            right_array_len,
            right_array,
            sorted_array,
            current_index + 1,
            left_array_index,
            right_array_index + 1,
        );
    }
}
