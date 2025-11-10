
module challenge::hero {

// ========= EVENTS =========

public struct HeroCreated has copy, drop {
    hero_id: ID,
    name: String,
    image_url: String,
    power: u64,
    timestamp: u64,
}

use std::string::String;

// ========= STRUCTS =========
public struct Hero has key, store {
    id: UID,
    name: String,
    image_url: String,
    power: u64,
}

public struct HeroMetadata has key, store {
    id: UID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

#[allow(lint(self_transfer))]
public fun create_hero(name: String, image_url: String, power: u64, ctx: &mut TxContext) {
    // Create the Hero object with a fresh id and the provided fields
    let hero = Hero {
        id: object::new(ctx),
        name: name,
        image_url: image_url,
        power,
    };

    // Transfer the newly created hero to the transaction sender
    transfer::transfer(hero, ctx.sender());

    // Create metadata for the hero and freeze it so it is immutable
    let metadata = HeroMetadata {
        id: object::new(ctx),
        timestamp: ctx.epoch_timestamp_ms(),
    };
    transfer::freeze_object(metadata);

}

// ========= GETTER FUNCTIONS =========

public fun hero_power(hero: &Hero): u64 {
    hero.power
}

#[test_only]
public fun hero_name(hero: &Hero): String {
    hero.name
}

#[test_only]
public fun hero_image_url(hero: &Hero): String {
    hero.image_url
}

#[test_only]
public fun hero_id(hero: &Hero): ID {
    object::id(hero)
}

} // end module

