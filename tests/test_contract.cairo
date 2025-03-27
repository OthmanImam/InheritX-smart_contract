#[test]
fn test_add_beneficiary_success() {
    // Declare and deploy the contract
    let inheritX_class = declare("InheritX").unwrap().contract_class();
    let (contract_address, _) = inheritX_class.deploy(@array![]).unwrap();

    let dispatcher = IInheritXDispatcher { contract_address };

    // Setup test parameters
    let plan_id = 1_u256;
    let owner = contract_address_const::<'owner'>();
    let beneficiary = contract_address_const::<'beneficiary'>();
    let name = 'Alice';
    let email = 'alice@inheritx.com';

    // Initialize plan
    dispatcher.set_plan_asset_owner(plan_id, owner);
    dispatcher.set_max_guardians(5_u8);

    // Execute test
    let result = dispatcher.add_beneficiary(plan_id, name, email, beneficiary);

    // Verify results
    assert(result == 0, 'Wrong index returned');

    let count = dispatcher.get_plan_beneficiaries_count(plan_id);

    assert(count == 1, 'Beneficiary count mismatch');
    assert(
        dispatcher.get_plan_beneficiaries(plan_id, 0_u32) == beneficiary, 'Beneficiary not stored',
    );
    assert(dispatcher.is_beneficiary(plan_id, beneficiary), 'Flag not set');
}
