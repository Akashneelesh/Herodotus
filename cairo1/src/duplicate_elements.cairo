fn find_duplicate_element<T, +Copy<T>, +Drop<T>, +PartialEq<T>>(mut array1: Array<T>) -> Array<T> {
    let mut new_array = array![];

    let mut i = 0;

    loop {
        if (i < array1.len() - 1) {
            if (*array1[i] != *array1[i + 1]) {
                new_array.append(*array1[i]);
            }
        } else {
            let val = array1.len() - 1;

            new_array.append(*array1[array1.len() - 1]);
            break;
        }
        i += 1;
    };

    new_array
}


#[cfg(test)]
mod tests {
    use super::find_duplicate_element;
    use array::{Span, SpanTrait, ArrayTrait};
    use alexandria_sorting::merge_sort::merge;

    #[test]
    #[available_gas(1000000)]
    fn test_multiple_elements() {
        let mut array1 = array![1_u8, 2_u8, 2_u8, 3_u8, 4_u8, 9_u8, 9_u8];
        let mut expected = array![1_u8, 2_u8, 3_u8, 4_u8, 9_u8];

        let new_array: Array<u8> = find_duplicate_element(array1);
        assert(new_array == expected, 'Invalid Array');
    }

    #[test]
    #[available_gas(1000000)]
    fn test_single_element() {
        let mut array1 = array![1_u8];
        let mut expected = array![1_u8];

        let new_array: Array<u8> = find_duplicate_element(array1);
        assert(new_array == expected, 'Invalid Array');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_unsorted_multiple_elements() {
        let mut array1: Array<u8> = array![1_u8, 2_u8, 3_u8, 7_u8, 4_u8, 2_u8, 4_u8, 9_u8];
        let mut expected = array![1_u8, 2_u8, 3_u8, 4_u8, 7_u8, 9_u8,];

        let mut new_ = merge(array1);

        let new_array: Array<u8> = find_duplicate_element(new_);
        assert(new_array == expected, 'Invalid Array');
    }
}

