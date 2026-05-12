/// Open-source PoC power-store facade.
///
/// Power upload, period advancement, retention, and version-selection internals
/// are intentionally omitted from this repository. Public and friend function
/// signatures are retained for source compatibility with framework callers.
module topo_framework::poc_power_store {
    use topo_std::table::Table;

    friend topo_framework::genesis;
    friend topo_framework::stake;
    friend topo_framework::staking_registry;

    /// Global power store, stored under @topo_framework.
    ///
    /// Invariants:
    /// - Only `operator` or @topo_framework may call `stage_batch_update`
    /// - Each user has at most two PowerVersion slots (older + newer)
    struct PowerStore has key {
        operator: address,
        users: Table<address, UserPowerInfo>,
        retention_bps_per_period: u64,
    }

    /// Global power-period clock, stored under @topo_framework.
    ///
    /// Invariants:
    /// - `current_period` only advances forward, never backward
    /// - `last_epoch` is incremented once per on-chain epoch via `commit_next_period_if_boundary`
    /// - `current_period` advances by at most one per committed epoch
    struct PeriodClock has key {
        power_period_in_epochs: u64,
        last_epoch: u64,
        current_period: u64,
        epochs_until_next_power_period: u64,
    }

    /// A single versioned power snapshot for a user.
    /// `effective_period` is the first period in which this value becomes the active reading.
    struct PowerVersion has copy, drop, store {
        effective_period: u64,
        power: u64,
    }

    /// Two-slot sliding window of power versions per user.
    ///
    /// Invariant: older.effective_period <= newer.effective_period (enforced by normalize_user_power_info).
    ///
    /// Why two slots?
    /// - When the operator stages period P+1 data while the chain is still in period P,
    ///   we must keep the period-P value so current reads remain stable.
    /// - At the period boundary, current_period advances to P+1 and reads switch to the newer slot.
    /// - The older slot is then free to be overwritten by the next staging call.
    struct UserPowerInfo has copy, drop, store {
        older: PowerVersion,
        newer: PowerVersion,
    }

    #[event]
    struct OperatorChangedEvent has drop, store {
        old_operator: address,
        new_operator: address,
    }

    #[event]
    /// Emitted for each user entry written by `stage_batch_update`.
    /// Allows off-chain indexers to track exactly what was staged and when.
    struct PowerUpdateStagedEvent has drop, store {
        /// The period the caller requested to stage for (must equal current_period + 1)
        target_period: u64,
        /// The period at which this power value becomes effective (equals target_period)
        effective_period: u64,
        user: address,
        power: u64,
    }

    #[event]
    /// Emitted when `commit_next_period_if_boundary` advances current_period.
    /// Off-chain services use this to know when a new period has started on-chain.
    struct PowerPeriodCommittedEvent has drop, store {
        previous_period: u64,
        current_period: u64,
    }

    /// Initialize the power store through the framework-only facade.
    friend fun initialize(topo_framework: &signer, operator: address) {
    }

    /// Initialize the power store with an explicit period length.
    friend fun initialize_with_power_period(
        topo_framework: &signer,
        operator: address,
        power_period_in_epochs: u64,
    ) {
    }

    /// Public initializer retained for compatibility.
    public entry fun initialize_power_store(
        topo_framework: &signer,
        operator: address,
    ) {
    }

    /// Public initializer retained for compatibility with explicit period length.
    public entry fun initialize_power_store_with_period(
        topo_framework: &signer,
        operator: address,
        power_period_in_epochs: u64,
    ) {
    }

    /// Set the per-period retention parameter.
    /// Open-source build validates resource access only.
    public entry fun set_retention_bps_per_period(
        topo_framework: &signer,
        retention_bps_per_period: u64,
    ) acquires PowerStore {
        touch_power_store();
    }

    /// Set the configured power-period length.
    /// Open-source build validates resource access only.
    public entry fun set_power_period_in_epochs(
        topo_framework: &signer,
        power_period_in_epochs: u64,
    ) acquires PeriodClock {
        touch_period_clock();
    }

    /// Set the operator address.
    /// Open-source build validates resource access only.
    public entry fun set_operator(
        topo_framework: &signer,
        new_operator: address,
    ) acquires PowerStore {
        touch_power_store();
    }

    /// Stage a batch power update.
    /// Open-source build keeps the entry point without storing power data.
    public entry fun stage_batch_update(
        operator: &signer,
        target_period: u64,
        users: vector<address>,
        powers: vector<u64>,
    ) acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
    }

    /// Seed a genesis committed power value.
    /// Open-source build keeps the entry point without storing power data.
    public entry fun set_genesis_committed_power(
        topo_framework: &signer,
        user: address,
        power: u64,
    ) acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
    }

    /// Advance the power-period clock at epoch boundaries.
    /// Open-source build keeps the hook as a no-op.
    friend fun commit_next_period_if_boundary() acquires PeriodClock {
        touch_period_clock();
    }

    #[view]
    /// Return a user's current power.
    /// Open-source build returns zero.
    public fun get_user_power(user: address): u64 acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
        0
    }

    #[view]
    /// Return a user's committed power.
    /// Open-source build returns zero.
    public fun get_user_committed_power(user: address): u64 acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
        0
    }

    #[view]
    /// Return a user's committed power for the next epoch.
    /// Open-source build returns zero.
    public fun get_user_committed_power_for_next_epoch(
        user: address,
    ): u64 acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
        0
    }

    #[view]
    /// Return a user's power for a specific period.
    /// Open-source build returns zero.
    public fun get_user_power_for_period(
        user: address,
        target_period: u64,
    ): u64 acquires PowerStore {
        touch_power_store();
        0
    }

    #[view]
    /// Return committed powers for a batch of users.
    /// Open-source build returns an empty vector.
    public fun get_user_committed_powers(
        users: vector<address>,
    ): vector<u64> acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
        vector[]
    }

    #[view]
    /// Return period-specific powers for a batch of users.
    /// Open-source build returns an empty vector.
    public fun get_user_powers_for_period(
        users: vector<address>,
        target_period: u64,
    ): vector<u64> acquires PowerStore {
        touch_power_store();
        vector[]
    }

    #[view]
    /// Return versioned power metadata for one user.
    /// Open-source build returns zero values.
    public fun get_user_power_version(
        user: address,
    ): (u64, u64, u64, u64, u64) acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
        (0, 0, 0, 0, 0)
    }

    #[view]
    /// Return versioned power metadata for a batch of users.
    /// Open-source build returns empty vectors.
    public fun get_user_power_versions_by_addresses(
        users: vector<address>,
    ): (
        vector<address>,
        vector<u64>,
        vector<u64>,
        vector<u64>,
        vector<u64>,
        vector<u64>,
    ) acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
        (vector[], vector[], vector[], vector[], vector[], vector[])
    }

    #[view]
    /// Return a user's decayed power.
    /// Open-source build returns zero.
    public fun get_user_decayed_power(user: address): u64 acquires PowerStore, PeriodClock {
        touch_power_store_and_clock();
        0
    }

    #[view]
    /// Return the configured operator.
    /// Open-source build returns the zero address.
    public fun get_operator(): address acquires PowerStore {
        touch_power_store();
        @0x0
    }

    #[view]
    /// Return the current power period.
    /// Open-source build returns zero.
    public fun get_current_period(): u64 acquires PeriodClock {
        touch_period_clock();
        0
    }

    #[view]
    /// Return the configured power-period length.
    /// Open-source build returns zero.
    public fun get_power_period_in_epochs(): u64 acquires PeriodClock {
        touch_period_clock();
        0
    }

    #[view]
    /// Return the configured retention rate.
    /// Open-source build returns zero.
    public fun get_retention_bps_per_period(): u64 acquires PowerStore {
        touch_power_store();
        0
    }

    /// Touch the power-store resource to preserve acquires compatibility.
    fun touch_power_store() acquires PowerStore {
        if (exists<PowerStore>(@topo_framework)) {
            let _store = borrow_global<PowerStore>(@topo_framework);
        };
    }

    /// Touch the period-clock resource to preserve acquires compatibility.
    fun touch_period_clock() acquires PeriodClock {
        if (exists<PeriodClock>(@topo_framework)) {
            let _clock = borrow_global<PeriodClock>(@topo_framework);
        };
    }

    /// Touch both PoC power resources to preserve acquires compatibility.
    fun touch_power_store_and_clock() acquires PowerStore, PeriodClock {
        touch_power_store();
        touch_period_clock();
    }
}
