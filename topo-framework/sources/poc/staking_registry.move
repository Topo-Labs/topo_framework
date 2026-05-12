/// Open-source PoC staking-registry facade.
///
/// Delegation accounting, validator power calculation, reward distribution, and
/// cooldown internals are intentionally omitted from this repository. Public and
/// friend function signatures are retained for source compatibility.
module topo_framework::staking_registry {
    use topo_std::simple_map::SimpleMap;

    use topo_framework::coin::{Self, MintCapability};
    use topo_framework::topo_coin::TopoCoin;

    friend topo_framework::genesis;
    friend topo_framework::stake;
    friend topo_framework::topo_governance;

    const VALIDATOR_STATUS_INACTIVE: u64 = 4;

    struct PendingMintCapability has key {}

    /// The global staking registry, stored under @topo_framework.
    ///
    /// Contains all validator pools, all user stake records, and the global config.
    /// The `mint_cap` is used to mint new TOPO coins as epoch rewards and fee distributions.
    struct StakingRegistry has key {}

    #[view]
    /// Return whether the staking registry exists.
    /// Open-source build returns false.
    public fun registry_exists(): bool {
        false
    }

    /// Store the TopoCoin mint capability before registry initialization.
    /// Open-source build destroys the capability instead of retaining reward authority.
    friend fun store_topo_coin_mint_cap(
        topo_framework: &signer,
        mint_cap: MintCapability<TopoCoin>,
    ) {
        coin::destroy_mint_cap(mint_cap);
    }

    /// Initialize the staking registry.
    /// Open-source build keeps the hook without creating staking state.
    friend fun initialize(
        topo_framework: &signer,
        octas_per_million_power: u64,
        max_delegators_per_validator: u64,
        cooldown_secs: u64,
    ) acquires PendingMintCapability {
        touch_pending_mint_capability();
    }

    /// Set active-power and force-exit thresholds.
    /// Open-source build validates resource access only.
    public entry fun set_active_power_thresholds(
        topo_framework: &signer,
        min_active_power: u64,
        force_exit_power_bps: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Set the minimum active power.
    /// Open-source build validates resource access only.
    public entry fun set_min_active_power(
        topo_framework: &signer,
        min_active_power: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Set the force-exit threshold in basis points.
    /// Open-source build validates resource access only.
    public entry fun set_force_exit_power_bps(
        topo_framework: &signer,
        force_exit_power_bps: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Set the deposit-to-power backing ratio.
    /// Open-source build validates resource access only.
    public entry fun set_octas_per_million_power(
        topo_framework: &signer,
        octas_per_million_power: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Set the staking cooldown duration.
    /// Open-source build validates resource access only.
    public entry fun set_cooldown_secs(
        topo_framework: &signer,
        cooldown_secs: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Ensure the cooldown duration is at least the requested minimum.
    /// Open-source build keeps the governance hook as a no-op.
    friend fun ensure_min_cooldown_secs(
        topo_framework: &signer,
        min_cooldown_secs: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Calculate genesis PoC power from a stake amount.
    /// Open-source build returns zero.
    friend fun calculate_genesis_power_from_stake(
        stake_amount: u64,
    ): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    /// Register the caller as a validator.
    /// Open-source build keeps the entry point without mutating validator state.
    public entry fun register_validator(
        validator: &signer,
        commission_bps: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Register a genesis validator.
    /// Open-source build keeps the hook without mutating validator state.
    friend fun register_validator_for_genesis(
        owner_address: address,
        validator_address: address,
        commission_bps: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Register a validator for an owner.
    /// Open-source build keeps the hook without mutating validator state.
    friend fun register_validator_for_owner(
        owner_address: address,
        validator_address: address,
        commission_bps: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Deposit TopoCoin into staking registry collateral.
    /// Open-source build keeps the entry point without moving funds.
    public entry fun deposit(
        user: &signer,
        amount: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Delegate staking collateral to a validator.
    /// Open-source build keeps the entry point without mutating delegation state.
    public entry fun delegate(
        user: &signer,
        validator_address: address,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Remove the caller's current delegation.
    /// Open-source build keeps the entry point without mutating delegation state.
    public entry fun undelegate(
        user: &signer,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Withdraw staking-registry collateral.
    /// Open-source build keeps the entry point without moving funds.
    public entry fun withdraw_deposit(
        user: &signer,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    #[view]
    /// Return a user's effective staking power.
    /// Open-source build returns zero.
    public fun get_effective_power(user: address): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    #[view]
    /// Return a validator's joining power.
    /// Open-source build returns zero.
    public fun get_validator_joining_power(
        validator_address: address,
    ): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    #[view]
    /// Return a validator's total power.
    /// Open-source build returns zero.
    public fun get_validator_total_power(
        validator_address: address,
    ): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    /// Return a validator's total power for the next epoch.
    /// Open-source build returns zero.
    friend fun get_validator_total_power_for_next_epoch(
        validator_address: address,
    ): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    /// Return next-epoch member powers for a validator.
    /// Open-source build returns empty member data.
    friend fun get_validator_member_powers_for_next_epoch(
        validator_address: address,
        extra_deposit_octas_by_user: &SimpleMap<address, u64>,
    ): (vector<address>, vector<u64>, u64) acquires StakingRegistry {
        touch_staking_registry();
        (vector[], vector[], 0)
    }

    /// Return current member powers for a validator.
    /// Open-source build returns empty member data.
    friend fun get_validator_member_powers_with_current_power(
        validator_address: address,
        extra_deposit_octas_by_user: &SimpleMap<address, u64>,
    ): (vector<address>, vector<u64>, u64) acquires StakingRegistry {
        touch_staking_registry();
        (vector[], vector[], 0)
    }

    #[view]
    /// Return total staked power.
    /// Open-source build returns zero.
    public fun get_total_staked_power(): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    #[view]
    /// Return whether a validator exists.
    /// Open-source build returns false.
    public fun validator_exists(validator_address: address): bool acquires StakingRegistry {
        touch_staking_registry();
        false
    }

    #[view]
    /// Return validator-existence flags for a batch.
    /// Open-source build returns an empty vector.
    public fun validators_exist(
        validators: vector<address>,
    ): vector<bool> acquires StakingRegistry {
        touch_staking_registry();
        vector[]
    }

    #[view]
    /// Return a compact validator view.
    /// Open-source build returns an inactive placeholder view.
    public fun get_validator_view(
        validator_address: address,
    ): (address, address, u64, u64, u64, u64, u64) acquires StakingRegistry {
        touch_staking_registry();
        (validator_address, @0x0, 0, VALIDATOR_STATUS_INACTIVE, 0, 0, 0)
    }

    #[view]
    /// Return compact validator views for a batch.
    /// Open-source build returns empty vectors.
    public fun get_validator_views_by_addresses(
        validators: vector<address>,
    ): (
        vector<address>,
        vector<address>,
        vector<u64>,
        vector<u64>,
        vector<u64>,
        vector<u64>,
        vector<u64>,
    ) acquires StakingRegistry {
        touch_staking_registry();
        (vector[], vector[], vector[], vector[], vector[], vector[], vector[])
    }

    #[view]
    /// Return a compact user stake view.
    /// Open-source build returns a zero-value placeholder view.
    public fun get_user_stake_view(
        user: address,
    ): (address, u64, address, u64, u64, u64) acquires StakingRegistry {
        touch_staking_registry();
        (user, 0, @0x0, 0, 0, 0)
    }

    #[view]
    /// Return stake-record existence flags for a batch.
    /// Open-source build returns an empty vector.
    public fun users_have_stake_records(
        users: vector<address>,
    ): vector<bool> acquires StakingRegistry {
        touch_staking_registry();
        vector[]
    }

    #[view]
    /// Return compact stake views for a batch of users.
    /// Open-source build returns empty vectors.
    public fun get_user_stake_views_by_addresses(
        users: vector<address>,
    ): (
        vector<address>,
        vector<u64>,
        vector<address>,
        vector<u64>,
        vector<u64>,
        vector<u64>,
    ) acquires StakingRegistry {
        touch_staking_registry();
        (vector[], vector[], vector[], vector[], vector[], vector[])
    }

    #[view]
    /// Return a validator's delegator count.
    /// Open-source build returns zero.
    public fun get_validator_delegator_count(
        validator_address: address,
    ): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    #[view]
    /// Return a paginated list of validator delegators.
    /// Open-source build returns an empty vector.
    public fun get_validator_delegators(
        validator_address: address,
        offset: u64,
        limit: u64,
    ): vector<address> acquires StakingRegistry {
        touch_staking_registry();
        vector[]
    }

    #[view]
    /// Return paginated delegator views for a validator.
    /// Open-source build returns empty vectors.
    public fun get_validator_delegator_views(
        validator_address: address,
        offset: u64,
        limit: u64,
    ): (vector<address>, vector<u64>, vector<u64>, vector<u64>) acquires StakingRegistry {
        touch_staking_registry();
        (vector[], vector[], vector[], vector[])
    }

    #[view]
    /// Return a user's deposit, delegation target, and cooldown timestamp.
    /// Open-source build returns zero-value stake info.
    public fun get_user_stake_info(
        user: address,
    ): (u64, address, u64) acquires StakingRegistry {
        touch_staking_registry();
        (0, @0x0, 0)
    }

    #[view]
    /// Return a validator's owner address.
    /// Open-source build returns the zero address.
    public fun get_validator_owner(
        validator_address: address,
    ): address acquires StakingRegistry {
        touch_staking_registry();
        @0x0
    }

    #[view]
    /// Return a validator's commission in basis points.
    /// Open-source build returns zero.
    public fun get_validator_commission_bps(
        validator_address: address,
    ): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    /// Set total staked power from the stake module.
    /// Open-source build keeps the hook as a no-op.
    friend fun set_total_staked_power(total_staked_power: u64) acquires StakingRegistry {
        touch_staking_registry();
    }

    #[view]
    /// Return the configured cooldown duration.
    /// Open-source build returns zero.
    public fun get_cooldown_secs(): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    #[view]
    /// Return the deposit-to-power backing ratio.
    /// Open-source build returns zero.
    public fun get_octas_per_million_power(): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    #[view]
    /// Return the configured minimum active power.
    /// Open-source build returns zero.
    public fun get_min_active_power(): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    #[view]
    /// Return the configured force-exit threshold in basis points.
    /// Open-source build returns zero.
    public fun get_force_exit_power_bps(): u64 acquires StakingRegistry {
        touch_staking_registry();
        0
    }

    /// Mark a validator as pending active.
    /// Open-source build keeps the hook as a no-op.
    friend fun set_validator_pending_active(
        validator_address: address,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Mark a validator as active.
    /// Open-source build keeps the hook as a no-op.
    friend fun set_validator_active(
        validator_address: address,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Mark a validator as pending inactive.
    /// Open-source build keeps the hook as a no-op.
    friend fun set_validator_pending_inactive(
        validator_address: address,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Mark a validator as inactive.
    /// Open-source build keeps the hook as a no-op.
    friend fun set_validator_inactive(
        validator_address: address,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Force-undelegate members below the configured threshold.
    /// Open-source build keeps the hook as a no-op.
    friend fun force_undelegate_below_threshold(
        validator_address: address,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Update a validator's commission.
    /// Open-source build keeps the hook as a no-op.
    friend fun update_validator_commission(
        validator_address: address,
        commission_bps: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Distribute epoch rewards for a validator.
    /// Open-source build keeps the hook without minting rewards.
    friend fun distribute_epoch_rewards(
        validator_address: address,
        num_successful_proposals: u64,
        num_total_proposals: u64,
        rewards_rate: u64,
        rewards_rate_denominator: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Distribute transaction fees for a validator.
    /// Open-source build keeps the hook without minting rewards.
    friend fun distribute_transaction_fees(
        validator_address: address,
        fee_amount_octa: u64,
    ) acquires StakingRegistry {
        touch_staking_registry();
    }

    /// Touch the pending mint-capability resource to preserve acquires compatibility.
    fun touch_pending_mint_capability() acquires PendingMintCapability {
        if (exists<PendingMintCapability>(@topo_framework)) {
            let _capability = borrow_global<PendingMintCapability>(@topo_framework);
        };
    }

    /// Touch the staking-registry resource to preserve acquires compatibility.
    fun touch_staking_registry() acquires StakingRegistry {
        if (exists<StakingRegistry>(@topo_framework)) {
            let _registry = borrow_global<StakingRegistry>(@topo_framework);
        };
    }
}
