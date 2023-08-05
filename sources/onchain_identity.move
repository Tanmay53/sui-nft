module sui_nft::onchain_identity {
    use sui::object::{ Self, UID };
    use sui::transfer;
    use sui::tx_context::{ Self, TxContext };
    use std::string::{ Self, String };
    use std::option::{ Self, Option };

    const EProfileMismatch:u64 =  0;

    struct AdminCap has key {
        id: UID
    }

    struct UserProfile has key {
        id: UID,
        user_address: address,
        name: String,
        bio: Option<String>,
        twitter_profile: Option<String>
    }

    public entry fun create_profile(name: vector<u8>, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        transfer::transfer(
            UserProfile {
                id: object::new(ctx),
                user_address: sender,
                name: string::utf8(name),
                bio: option::none(),
                twitter_profile: option::none()
            },
            sender
        );
    }

    public entry fun change_bio(user_profile: &mut UserProfile, bio: vector<u8>, ctx: &mut TxContext) {
        assert!( tx_context::sender(ctx) == user_profile.user_address, EProfileMismatch);

        let old_bio = option::swap_or_fill(&mut user_profile.bio, string::utf8(bio));

        _ = old_bio;
    }

    public fun delete_profile(_: &AdminCap, user_profile: UserProfile) {
        let UserProfile{
            id,
            user_address: _,
            name: _,
            bio: _,
            twitter_profile: _
        } = user_profile;

        object::delete(id);
    }
}