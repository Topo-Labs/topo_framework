/// Open-source PoC contribution facade.
///
/// The public function signatures and event type are kept for ABI/source
/// compatibility, while the contribution transfer and event-emission logic is
/// intentionally omitted from this repository.
module topo_framework::poc_contribution {
    use topo_framework::fungible_asset::Metadata;
    use topo_framework::object::Object;

    #[event]
    /// Trusted contribution event — the protocol boundary of the POC power system.
    ///
    /// This event signifies: this module has completed a registry-validated standard equity
    /// distribution within the current transaction. The recipient is `contributor` and the
    /// platform-recognized target received amount is `equity_amount`.
    ///
    /// Sources of trustworthiness:
    /// - Event is emitted by the `poc_contribution` module (not by the application itself)
    /// - Event is only emitted after a real token transfer has succeeded
    /// - Key asset parameters (equity_token, custody_address) come from the registry, not external input
    /// - Off-chain indexers can cross-validate against the FA transfer event in the same transaction
    ///
    /// Off-chain indexers use this event to:
    /// 1. Identify which application made the contribution (via app_address)
    /// 2. Record the contributor's equity receipt for POC power calculation
    /// 3. Aggregate contribution data across periods for the operator to upload to poc_power_store
    struct ContributionEvent has drop, store {
        contributor: address,
        equity_token: Object<Metadata>,
        equity_amount: u64,
        app_address: address,
        period: u64,
    }

    /// Grant equity through the public contribution facade.
    /// Open-source build keeps the signature and omits transfer/event logic.
    public fun grant_equity_with_contribution(
        app_signer: &signer,
        custody_actor: &signer,
        contributor: address,
        equity_amount: u64,
    ) {
    }

    /// Grant equity through the strict contribution facade.
    /// Open-source build keeps the signature and omits validation/transfer/event logic.
    public fun grant_equity_with_contribution_strict(
        app_signer: &signer,
        custody_actor: &signer,
        contributor: address,
        equity_amount: u64,
    ) {
    }
}
