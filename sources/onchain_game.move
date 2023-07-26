module sui_nft::onchain_game {
    use sui::transfer;
    use sui::object{ Self, UID };
    use sui::tx_context{ Self, TxContext };
    use sui::url{ Self, Url };
    use sui::string{ Self, String };
    use sui::option{ Self, Option };

    struct GameAdminCap has key {
        id: UID
    }

    struct Hero has key {
        id: UID,
        name: String,
        level: u64,
        hitpoints: u64,
        xp: u64,
        url: Url,
        sword: Option<Sword>
    }

    struct Sword has key, store {
        id: UID,
        min_level: u64,
        strength: u64
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(
            GameAdminCap{
                id: object::new(ctx)
            },
            tx_context::sender(ctx)
        )
    }

    public entry fun create_hero(
        _: &GameAdminCap,
        player: address,
        name: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        transfer::transfer(
            Hero {
                id: object::new(ctx),
                name: string::utf8(name),
                level: 1,
                hitpoints: 100,
                xp: 0,
                url: url::new_unsafe_from_bytes(url),
                sword: option::none()
            },
            tx_context::sender(ctx)
        )
    }
}
