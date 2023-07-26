module sui_nft::object_basics {
    sui::transfer;
    sui::object::{ Self, UID };
    sui::tx_context::{ Self, TxContext };
    sui::dynamic_object_field as ofield;

    struct ObjectA has key {
        id: UID
    }

    public entry fun create_object_by_an_address(ctx: &mut TxContext) {
        transfer::transfer(
            {
                ObjectA{
                    id: object::new(ctx)
                }
            },
            tx_context::sender(ctx)
        );
    }

    struct ObjectB has key, store {
        id: UID
    }

    public entry fun create_object_owned_by_object(parent: &mut ObjectA, ctx: &mut TxContext) {
        let child = ObjectB{ id: object::new(ctx) };
        ofield::new(&mut parent.id, b"child", child);
    }

    struct ObjectC has key {
        id: UID
    }

    public entry fun create_shared_object(ctx: &mut TxContext) {
        transfer::share_object(ObjectC { id: object::new(ctx) });
    }

    struct ObjectD has key {
        id: UID
    }

    public entry fun create_immutable_object(ctx: &mut TxContext) {
        transfer::freeze_object(ObjectD { id: object::new(ctx) });
    }
}
