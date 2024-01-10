trait HasherTrait<T> {
    fn new() -> T;
    fn hash(ref self: T, data1: felt252, data2: felt252) -> felt252;
}


#[derive(Drop, Copy)]
struct Hasher {}


mod pedersen {
    use hash::HashStateTrait;
    use pedersen::PedersenTrait;
    use super::{Hasher, HasherTrait};

    impl PedersenHasherImpl of HasherTrait<Hasher> {
        fn new() -> Hasher {
            Hasher {}
        }
        fn hash(ref self: Hasher, data1: felt252, data2: felt252) -> felt252 {
            let mut state = PedersenTrait::new(data1);
            state = state.update(data2);
            state.finalize()
        }
    }
}


#[derive(Drop)]
struct MerkleTree<T> {
    hasher: T
}


trait MerkleTreeTrait<T> {
    fn new() -> MerkleTree<T>;

    fn compute_root(
        ref self: MerkleTree<T>, current_node: felt252, proof: Span<felt252>
    ) -> felt252;

    fn verify(ref self: MerkleTree<T>, root: felt252, leaf: felt252, proof: Span<felt252>) -> bool;

    fn compute_proof(ref self: MerkleTree<T>, leaves: Array<felt252>, index: u32) -> Span<felt252>;
}


impl MerkleTreeImpl<T, +HasherTrait<T>, +Copy<T>, +Drop<T>> of MerkleTreeTrait<T> {
    fn new() -> MerkleTree<T> {
        MerkleTree { hasher: HasherTrait::new() }
    }

    fn compute_root(
        ref self: MerkleTree<T>, mut current_node: felt252, mut proof: Span<felt252>
    ) -> felt252 {
        loop {
            match proof.pop_front() {
                Option::Some(proof_element) => {
                    current_node =
                        //Conversion of felt252 into u256
                        if Into::<felt252, u256>::into(current_node) < (*proof_element).into() {
                            self.hasher.hash(current_node, *proof_element)
                        } else {
                            self.hasher.hash(*proof_element, current_node)
                        };
                },
                Option::None => { break current_node; },
            };
        }
    }

    fn verify(
        ref self: MerkleTree<T>, root: felt252, mut leaf: felt252, mut proof: Span<felt252>
    ) -> bool {
        let computed_root = loop {
            match proof.pop_front() {
                Option::Some(proof_element) => {
                    leaf =
                        if Into::<felt252, u256>::into(leaf) < (*proof_element).into() {
                            self.hasher.hash(leaf, *proof_element)
                        } else {
                            self.hasher.hash(*proof_element, leaf)
                        };
                },
                Option::None => { break leaf; },
            };
        };
        computed_root == root
    }

    fn compute_proof(
        ref self: MerkleTree<T>, mut leaves: Array<felt252>, index: u32
    ) -> Span<felt252> {
        let mut proof: Array<felt252> = array![];
        compute_proof(leaves, self.hasher, index, ref proof);
        proof.span()
    }
}

fn compute_proof<T, +HasherTrait<T>, +Drop<T>>(
    mut nodes: Array<felt252>, mut hasher: T, index: u32, ref proof: Array<felt252>
) {
    if nodes.len() == 1 {
        return;
    }

    if nodes.len() % 2 != 0 {
        nodes.append(0);
    }

    let mut next_level: Array<felt252> = get_next_level(nodes.span(), ref hasher);

    let mut index_parent = 0;
    let mut i = 0;
    loop {
        if i == index {
            index_parent = i / 2;
            if i % 2 == 0 {
                proof.append(*nodes.at(i + 1));
            } else {
                proof.append(*nodes.at(i - 1));
            }
            break;
        }
        i += 1;
    };

    compute_proof(next_level, hasher, index_parent, ref proof)
}


fn get_next_level<T, +HasherTrait<T>, +Drop<T>>(
    mut nodes: Span<felt252>, ref hasher: T
) -> Array<felt252> {
    let mut next_level: Array<felt252> = array![];
    loop {
        if nodes.is_empty() {
            break;
        }
        let left = *nodes.pop_front().expect('Index out of bounds');
        let right = *nodes.pop_front().expect('Index out of bounds');
        let node = if Into::<felt252, u256>::into(left) < right.into() {
            hasher.hash(left, right)
        } else {
            hasher.hash(right, left)
        };
        next_level.append(node);
    };
    next_level
}

#[cfg(test)]
mod tests {
    use array::{Span, SpanTrait, ArrayTrait};
    use cairo1::merkle_tree::{Hasher, MerkleTree, pedersen::PedersenHasherImpl, MerkleTreeTrait,};

    #[test]
    #[available_gas(1000000000)]
    fn test_merkle() {
        let mut merkle_tree_: MerkleTree<Hasher> = MerkleTreeTrait::new();

        let root = 0x4c5b879125d0fe0e0359dc87eea9c7370756635ca87c59148fb313c2cfb0579;
        let leaf = 0x57d0e61d7b5849581495af551721710023a83e705710c58facfa3f4e36e8fac;
        let valid_proof = array![0x3bf438e95d7428d14eb4270528ff8b1e2f9cb30113724626d5cf9943551ee4d]
            .span();

        let leaves = array![
            0x3bf438e95d7428d14eb4270528ff8b1e2f9cb30113724626d5cf9943551ee4d,
            0x57d0e61d7b5849581495af551721710023a83e705710c58facfa3f4e36e8fac
        ];

        let computed_root = merkle_tree_.compute_root(leaf, valid_proof);
        assert(computed_root == root, ' Computing root failed');

        let mut input_leaves = leaves;
        let index = 1;
        let computed_proof = merkle_tree_.compute_proof(input_leaves, index);
        assert(computed_proof == valid_proof, 'Computing proof failed');

        let result = merkle_tree_.verify(root, leaf, valid_proof);
        assert(result, 'Verifiying proof failed');
    }

    #[test]
    #[should_panic(expected: ('Verifiying proof failed',))]
    #[available_gas(1000000000)]
    fn test_invalid_merkle() {
        let mut merkle_tree_: MerkleTree<Hasher> = MerkleTreeTrait::new();

        let root = 0x4c5b879125d0fe0e0359dc87eea9c7370756635ca87c59148fb313c2cfb0579;
        let leaf = 0x57d0e61d7b5849581495af551721710023a83e705710c58facfa3f4e36e8fac;
        let valid_proof = array![0x3bf438e95d7428d14eb4270528ff8b1e2f9cb30113724626d5cf9943551ee4d]
            .span();

        let leaves = array![
            0x3bf438e95d7428d14eb4270528ff8b1e2f9cb30113724626d5cf9943551ee4d,
            0x57d0e61d7b5849581495af551721710023a83e705710c58facfa3f4e36e8fac
        ];

        let invalid_leaf = leaf + 1;

        let result = merkle_tree_.verify(root, invalid_leaf, valid_proof);
        assert(result, 'Verifiying proof failed');
    }
}
