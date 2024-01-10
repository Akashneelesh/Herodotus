use core::array::ArrayTrait;
use alexandria_data_structures::array_ext;

fn duplicate_element(val: Array<u8>) -> Array<u8> {
    array_ext::SpanTraitExt::unique(val.span())
}
#[cfg(test)]
mod tests {
    use debug::PrintTrait;
    use super::duplicate_element;
    use array::{Span, SpanTrait, ArrayTrait};

    #[test]
    #[available_gas(1000000)]
    fn test_duplicate_elements() {
        let mut array1 = array![1_u8, 2_u8, 5_u8, 2_u8, 3_u8, 1_u8];
        let mut expected = array![1_u8, 2_u8, 5_u8, 3_u8];

        let new_array: Array<u8> = duplicate_element(array1);
        assert(new_array == expected, 'Invalid Array');
    }

    #[test]
    #[available_gas(1000000)]
    fn test_single_element() {
        let mut array1 = array![2_u8];
        let mut expected = array![2_u8];

        let new_array: Array<u8> = duplicate_element(array1);
        assert(new_array == expected, 'Invalid Array');
    }
}

