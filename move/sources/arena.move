module challenge::arena;

use challenge::hero::Hero;
use sui::event;

// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {
    // Create an Arena object with a unique ID
    let arena = Arena {
        id: object::new(ctx),
        warrior: hero,
        owner: ctx.sender(),
    };

    // Emit the ArenaCreated event with the arena ID and timestamp
    event::emit(ArenaCreated {
        arena_id: object::id(&arena),
        timestamp: ctx.epoch_timestamp_ms(),
    });

    // Make the arena object publicly tradeable
    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    let Arena { id, warrior, owner } = arena;
    let hero_power = challenge::hero::hero_power(&hero);
    let warrior_power = challenge::hero::hero_power(&warrior);
    let hero_id = object::id(&hero);
    let warrior_id = object::id(&warrior);

    if (hero_power > warrior_power) {
        // Hero wins: transfer both heroes to the transaction sender
        transfer::public_transfer(hero, ctx.sender());
        transfer::public_transfer(warrior, ctx.sender());

        event::emit(ArenaCompleted {
            winner_hero_id: hero_id,
            loser_hero_id: warrior_id,
            timestamp: ctx.epoch_timestamp_ms(),
        });
    } else {
        // Warrior wins: transfer both heroes to the arena owner
        transfer::public_transfer(hero, owner);
        transfer::public_transfer(warrior, owner);

        event::emit(ArenaCompleted {
            winner_hero_id: warrior_id,
            loser_hero_id: hero_id,
            timestamp: ctx.epoch_timestamp_ms(),
        });
    }
    ;
    object::delete(id);
}

