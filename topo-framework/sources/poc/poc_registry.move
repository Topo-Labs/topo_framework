/// Open-source PoC registry facade.
///
/// The application registry API is retained for source compatibility. Registry
/// mutation and lookup internals are intentionally omitted from this repository.
module topo_framework::poc_registry {
    use std::string::{Self, String};

    use topo_std::table::Table;

    const APP_STATE_ACTIVE: u8 = 1;
    const APP_STATE_STOPPED: u8 = 3;
    const POC_LISTING_STATUS_REGISTERED: u8 = 1;
    const DEFAULT_EFFECTIVE_WEIGHT_PBS: u64 = 10000;

    /// Global registry, stored under @topo_framework, initialized at genesis.
    ///
    /// Maintains 4 lookup tables to support reverse-lookup from any of:
    /// admin address, contract address, custody address, or equity token address
    /// back to the same registered entity.
    ///
    /// The multi-index design allows `poc_contribution` to efficiently validate
    /// all three address dimensions (app_address, custody_address, equity_token)
    /// in O(1) without scanning the full registry.
    struct Registry has key {
        apps: Table<address, AppInfo>,
        app_address_to_admin: Table<address, address>,
        custody_address_to_admin: Table<address, address>,
        equity_token_to_admin: Table<address, address>,
    }

    /// Complete registration record for a Dapp application.
    struct AppInfo has copy, drop, store {
        /// Administrator identity address (primary key); holds highest management authority for this app
        app_admin: address,
        /// Contract deployment address; the on-chain entry module address for this application.
        /// Can be updated by the admin (e.g., after contract upgrade/redeployment), but must remain globally unique.
        app_address: address,
        /// Equity token address (analogous to an ERC-20 contract address on Ethereum).
        /// Must be a valid Fungible Asset Metadata object address.
        /// IMPORTANT: Changing this resets poc_listing_status to REGISTERED, requiring platform re-review.
        equity_token_address: address,
        /// Custody address holding equity tokens pending distribution.
        /// During trusted contribution events, only this address's signer can transfer tokens out.
        custody_address: address,
        /// Application's self-managed operational state (APP_STATE_ACTIVE / PAUSED / STOPPED).
        /// Controlled exclusively by the app_admin.
        app_state: u8,
        /// Platform POC inclusion status (POC_LISTING_STATUS_REGISTERED / WHITELISTED / SUSPENDED).
        /// Controlled by the chain's DAO governance organization (currently @topo_framework).
        poc_listing_status: u8,
        /// Application's official website or authoritative information link
        metadata_uri: String,
        /// Effective weight in per-basis-points (0–10000). 10000 = 100% weight.
        /// Controlled by @topo_framework / DAO governance to adjust the app's actual contribution weight.
        effective_weight_pbs: u64,
    }

    #[event]
    /// Emitted when a new application is successfully registered
    struct AppRegisteredEvent has drop, store {
        app_admin: address,
        app_address: address,
        equity_token_address: address,
        custody_address: address,
    }

    #[event]
    /// Emitted when the contract deployment address is updated (e.g., after contract upgrade)
    struct AppAddressUpdatedEvent has drop, store {
        app_admin: address,
        old_app_address: address,
        new_app_address: address,
    }

    #[event]
    /// Emitted when the equity token address is updated.
    /// Note: this also triggers an automatic reset of poc_listing_status to REGISTERED.
    struct AppEquityTokenUpdatedEvent has drop, store {
        app_admin: address,
        old_equity_token_address: address,
        new_equity_token_address: address,
    }

    #[event]
    /// Emitted when the custody address is updated
    struct AppCustodyUpdatedEvent has drop, store {
        app_admin: address,
        old_custody_address: address,
        new_custody_address: address,
    }

    #[event]
    /// Emitted when the application's self-managed operational state changes
    struct AppStateChangedEvent has drop, store {
        app_admin: address,
        old_app_state: u8,
        new_app_state: u8,
    }

    #[event]
    /// Emitted when the platform POC inclusion status changes
    struct AppPocListingStatusChangedEvent has drop, store {
        app_admin: address,
        old_poc_listing_status: u8,
        new_poc_listing_status: u8,
    }

    #[event]
    /// Emitted when the effective weight is updated by the platform
    struct AppEffectiveWeightUpdatedEvent has drop, store {
        app_admin: address,
        old_effective_weight_pbs: u64,
        new_effective_weight_pbs: u64,
    }

    /// Initialize the registry through the framework-only facade.
    friend fun initialize(topo_framework: &signer) {
    }

    /// Public initializer retained for compatibility.
    public entry fun initialize_registry(topo_framework: &signer) {
    }

    /// Register an application in the PoC registry.
    /// Open-source build keeps the entry point without storing registry data.
    public entry fun register_app(
        app_admin: &signer,
        app_address: address,
        equity_token_address: address,
        custody_address: address,
        metadata_uri: String,
    ) acquires Registry {
        touch_registry();
    }

    /// Update the registered application address.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun update_app_address(
        app_admin: &signer,
        new_app_address: address,
    ) acquires Registry {
        touch_registry();
    }

    /// Update the registered equity-token address.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun update_equity_token_address(
        app_admin: &signer,
        new_equity_token_address: address,
    ) acquires Registry {
        touch_registry();
    }

    /// Update the registered custody address.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun update_custody_address(
        app_admin: &signer,
        new_custody_address: address,
    ) acquires Registry {
        touch_registry();
    }

    /// Pause a registered application.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun pause_app(app_admin: &signer) acquires Registry {
        touch_registry();
    }

    /// Resume a registered application.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun resume_app(app_admin: &signer) acquires Registry {
        touch_registry();
    }

    /// Permanently stop a registered application.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun stop_app(app_admin: &signer) acquires Registry {
        touch_registry();
    }

    /// Set the PoC listing status for an application.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun set_poc_listing_status(
        topo_framework: &signer,
        app_admin: address,
        new_poc_listing_status: u8,
    ) acquires Registry {
        touch_registry();
    }

    /// Suspend an application's PoC listing.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun suspend_poc_listing(
        topo_framework: &signer,
        app_admin: address,
    ) acquires Registry {
        touch_registry();
    }

    /// Whitelist an application for PoC listing.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun whitelist_app_for_poc(
        topo_framework: &signer,
        app_admin: address,
    ) acquires Registry {
        touch_registry();
    }

    /// Set an application's effective contribution weight.
    /// Open-source build keeps the entry point without mutating registry data.
    public entry fun set_effective_weight_pbs(
        topo_framework: &signer,
        app_admin: address,
        new_effective_weight_pbs: u64,
    ) acquires Registry {
        touch_registry();
    }

    #[view]
    /// Return whether an application exists.
    /// Open-source build returns false.
    public fun exists_app(app_admin: address): bool acquires Registry {
        touch_registry();
        false
    }

    #[view]
    /// Return existence flags for a batch of applications.
    /// Open-source build returns an empty vector.
    public fun exists_apps(app_admins: vector<address>): vector<bool> acquires Registry {
        touch_registry();
        vector[]
    }

    #[view]
    /// Return app records for explicit admin addresses.
    /// Open-source build returns an empty vector.
    public fun get_app_infos_by_admins(
        app_admins: vector<address>,
    ): vector<AppInfo> acquires Registry {
        touch_registry();
        vector[]
    }

    #[view]
    /// Return admin addresses by app contract addresses.
    /// Open-source build returns an empty vector.
    public fun get_app_admins_by_app_addresses(
        app_addresses: vector<address>,
    ): vector<address> acquires Registry {
        touch_registry();
        vector[]
    }

    #[view]
    /// Return the app admin for an app contract address.
    /// Open-source build returns the zero address.
    public fun get_app_admin_by_app_address(
        app_address: address,
    ): address acquires Registry {
        touch_registry();
        @0x0
    }

    #[view]
    /// Return the app admin for a custody address.
    /// Open-source build returns the zero address.
    public fun get_app_admin_by_custody_address(
        custody_address: address,
    ): address acquires Registry {
        touch_registry();
        @0x0
    }

    #[view]
    /// Return the app admin for an equity-token address.
    /// Open-source build returns the zero address.
    public fun get_app_admin_by_equity_token(
        equity_token_address: address,
    ): address acquires Registry {
        touch_registry();
        @0x0
    }

    #[view]
    /// Return the app record for an admin address.
    /// Open-source build returns an empty placeholder record.
    public fun get_app_info(app_admin: address): AppInfo acquires Registry {
        touch_registry();
        AppInfo {
            app_admin: @0x0,
            app_address: @0x0,
            equity_token_address: @0x0,
            custody_address: @0x0,
            app_state: APP_STATE_STOPPED,
            poc_listing_status: POC_LISTING_STATUS_REGISTERED,
            metadata_uri: string::utf8(b""),
            effective_weight_pbs: DEFAULT_EFFECTIVE_WEIGHT_PBS,
        }
    }

    #[view]
    /// Return the app record for an app contract address.
    /// Open-source build returns an empty placeholder record.
    public fun get_app_info_by_app_address(
        app_address: address,
    ): AppInfo acquires Registry {
        get_app_info(@0x0)
    }

    #[view]
    /// Return the registered app contract address.
    /// Open-source build returns the zero address.
    public fun get_app_address(app_admin: address): address acquires Registry {
        touch_registry();
        @0x0
    }

    #[view]
    /// Return the registered equity-token address.
    /// Open-source build returns the zero address.
    public fun get_equity_token_address(app_admin: address): address acquires Registry {
        touch_registry();
        @0x0
    }

    #[view]
    /// Return the registered custody address.
    /// Open-source build returns the zero address.
    public fun get_custody_address(app_admin: address): address acquires Registry {
        touch_registry();
        @0x0
    }

    #[view]
    /// Return the application state.
    /// Open-source build returns STOPPED.
    public fun get_app_state(app_admin: address): u8 acquires Registry {
        touch_registry();
        APP_STATE_STOPPED
    }

    #[view]
    /// Return the PoC listing status.
    /// Open-source build returns REGISTERED.
    public fun get_poc_listing_status(app_admin: address): u8 acquires Registry {
        touch_registry();
        POC_LISTING_STATUS_REGISTERED
    }

    #[view]
    /// Return the metadata URI.
    /// Open-source build returns an empty string.
    public fun get_metadata_uri(app_admin: address): String acquires Registry {
        touch_registry();
        string::utf8(b"")
    }

    #[view]
    /// Return the effective weight in basis points.
    /// Open-source build returns the default weight.
    public fun get_effective_weight_pbs(app_admin: address): u64 acquires Registry {
        touch_registry();
        DEFAULT_EFFECTIVE_WEIGHT_PBS
    }

    #[view]
    /// Return whether an application is active.
    /// Open-source build returns false.
    public fun is_app_active(app_admin: address): bool acquires Registry {
        touch_registry();
        false
    }

    #[view]
    /// Return whether an application is PoC listed.
    /// Open-source build returns false.
    public fun is_poc_listed(app_admin: address): bool acquires Registry {
        touch_registry();
        false
    }

    #[view]
    /// Return whether an application is eligible for PoC.
    /// Open-source build returns false.
    public fun is_app_eligible_for_poc(app_admin: address): bool acquires Registry {
        touch_registry();
        false
    }

    /// Touch the registry resource to preserve acquires compatibility.
    fun touch_registry() acquires Registry {
        if (exists<Registry>(@topo_framework)) {
            let _registry = borrow_global<Registry>(@topo_framework);
        };
    }
}
