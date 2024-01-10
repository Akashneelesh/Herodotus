
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from starkware.cairo.common.alloc import alloc

from src.merge_sort import mergesort_elements,Array

from src.if_range import check_quarter


@view
func test_sort_tickelem_arr1{range_check_ptr}() {

    let elem1 = Array(value=53);
    let elem2 = Array(value=35);
    let elem3 = Array(value=34);
    let elem4 = Array(value=21);
    let elem5 = Array(value=7);
    let (arr: Array*) = alloc();
    assert arr[0] = elem1;
    assert arr[1] = elem2;
    assert arr[2] = elem3;
    assert arr[3] = elem4;
    assert arr[4] = elem5;

    let (sorted_arr) = mergesort_elements(5, arr);
    assert sorted_arr[0].value = 7;
    assert sorted_arr[1].value = 21;
    assert sorted_arr[2].value = 34;

    return ();
}


@view
func test_sort_tickelem_arr2{range_check_ptr}() {

    alloc_locals;

    

    let elem1 = Array(value=1);
    let elem2 = Array(value=9);
    let elem3 = Array(value=9);
    let elem4 = Array(value=5);
    let elem5 = Array(value=3);
    let (local arr: Array*) = alloc();
    assert arr[0] = elem1;
    assert arr[1] = elem2;
    assert arr[2] = elem3;
    assert arr[3] = elem4;
    assert arr[4] = elem5;

    let (local sorted_arr) = mergesort_elements(5, arr);
    assert sorted_arr[0].value = 1;
    assert sorted_arr[1].value = 3;
    assert sorted_arr[2].value = 5;

    // %{
    //     inputs = memory.get_range(ids.arr,5)

    //     print(inputs)
        

    //     cairo_res = memory.get_range(ids.sorted_arr, 4)
    //     print(cairo_res)

    //     expected_res = sort(inputs)
    //     assert expected_res == cairo_res
        
        
    // %}

    return ();
}

@view
func test_sort_tickelem_arr3{range_check_ptr}() {

    let elem1 = Array(value=1);

    let (arr: Array*) = alloc();
    assert arr[0] = elem1;

    let (sorted_arr) = mergesort_elements(1, arr);
    assert sorted_arr[0].value = 1;


    return ();
}


@view
func test_check_quarter{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
   
    alloc_locals;
    local val1 = 2;
    let (res1) = check_quarter(val1);
    assert res1 = 1;

    local val2 = 6;
    let (res2) = check_quarter(val2);
    assert res2 = 2;

    local val3 = 10;
    let (res3) = check_quarter(val3);
    assert res3 = 3;

    local val4 = 13;
    let (res4) = check_quarter(val4);
    assert res4 = 4;

    return();

}
