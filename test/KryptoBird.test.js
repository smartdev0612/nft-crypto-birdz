const { assert } = require('chai');

const KryptoBird = artifacts.require('./KryptoBirdz');

// check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird', (accounts) => {
    let contract

    // testing container - describe
    describe('deployment', async () => {
        // text samples with writing it
        it('should be deployed successfully', async () => {
            contract = await KryptoBird.deployed()
            const address = contract.address
            assert.notEqual(address, '')
            assert.notEqual(address, null)
            assert.notEqual(address, undefined)
            assert.notEqual(address, 0x0)
        })

        // 
    })
})