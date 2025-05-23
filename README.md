# BuildWise Construction Management System

A decentralized construction resource management platform built on the Stacks blockchain using Clarity smart contracts. BuildWise enables construction companies to manage materials, workforce, and machinery with transparent, immutable records and robust access controls.

## 🏗️ Overview

BuildWise provides a secure, blockchain-based solution for construction project management, offering:

- **Material Inventory Management**: Track stock levels, pricing, and supplier information
- **Workforce Administration**: Manage worker profiles, wage rates, and certifications
- **Machinery Operations**: Monitor equipment maintenance schedules and operational status
- **Decentralized Access Control**: Ensure only authorized personnel can modify critical data
- **Transparent Audit Trail**: Immutable records of all resource management activities

## 🚀 Features

### Core Functionality
- ✅ **Multi-Resource Management**: Handle materials, workforce, and machinery in a unified system
- ✅ **Role-Based Access Control**: Administrative functions restricted to contract owner
- ✅ **Data Validation**: Comprehensive input validation for all operations
- ✅ **Error Handling**: Detailed error codes for debugging and user feedback
- ✅ **Optional Updates**: Flexible modification system for existing records

### Smart Contract Features
- **Gas Efficient**: Optimized Clarity code for minimal transaction costs
- **Secure by Design**: Multiple validation layers and authorization checks
- **Extensible Architecture**: Modular design for future feature additions
- **Type Safety**: Strict typing ensures data integrity

## 📋 Prerequisites

- [Stacks CLI](https://docs.stacks.co/stacks-cli) installed
- [Clarinet](https://github.com/hirosystems/clarinet) for local development and testing
- Basic understanding of Clarity smart contracts
- Stacks testnet/mainnet wallet for deployment

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/iamifeoma/BuildWise-Construction.git
   cd BuildWise-Construction
   ```

2. **Initialize Clarinet project**
   ```bash
   clarinet new buildwise
   cd buildwise
   ```

3. **Add the contract**
   ```bash
   # Copy the buildwise-management.clar file to contracts/
   cp ../buildwise-management.clar contracts/
   ```

4. **Update Clarinet.toml**
   ```toml
   [contracts.buildwise-management]
   path = "contracts/buildwise-management.clar"
   ```

## 📖 Usage

### Contract Initialization

Before using any functionality, the contract must be activated by the admin:

```clarity
(contract-call? .buildwise-management activate-system)
```

### Managing Materials

**Register a new material:**
```clarity
(contract-call? .buildwise-management register-material 
    u1                    ;; item-id
    "Steel Rebar"         ;; item-name
    u500                  ;; stock-level
    u25                   ;; cost-per-unit (in microSTX)
)
```

### Managing Workforce

**Register a new worker:**
```clarity
(contract-call? .buildwise-management register-worker
    u1                    ;; worker-id
    "John Smith"          ;; worker-name
    u50                   ;; wage-rate (per hour in microSTX)
)
```

### Managing Machinery

**Register new equipment:**
```clarity
(contract-call? .buildwise-management register-machine
    u1                    ;; machine-id
    "Excavator CAT320"    ;; machine-name
    "Monthly"             ;; service-interval
)
```

**Update existing equipment:**
```clarity
(contract-call? .buildwise-management modify-machine
    u1                              ;; machine-id
    (some "Excavator CAT320D")      ;; new-machine-name (optional)
    (some "Bi-weekly")              ;; new-service-interval (optional)
)
```

**Inspect equipment details:**
```clarity
(contract-call? .buildwise-management inspect-machine u1)
```

## 🔒 Security Features

### Access Control
- **Admin-Only Operations**: Critical functions restricted to contract deployer
- **System Activation**: Contract must be explicitly activated before use
- **Input Validation**: Comprehensive validation for all user inputs

### Data Integrity
- **Unique Identifiers**: Prevents duplicate entries across all resource types
- **Type Safety**: Strict typing prevents data corruption
- **Bounds Checking**: Validates all numeric inputs within reasonable ranges

### Error Handling
| Error Code | Description |
|------------|-------------|
| `ERR-PERMISSION-DENIED (u1)` | Unauthorized access attempt |
| `ERR-ITEM-EXISTS (u2)` | Attempting to create duplicate entry |
| `ERR-ITEM-NOT-FOUND (u404)` | Requested item doesn't exist |
| `ERR-INVALID-PARAMETER (u3)` | Invalid input parameter |
| `ERR-SETUP-REQUIRED (u4)` | Contract not yet activated |
| `ERR-INVALID-ITEM-ID (u5)` | Invalid identifier provided |

## 🧪 Testing

Run the test suite using Clarinet:

```bash
clarinet test
```

### Example Test Cases
- Contract initialization and activation
- Material registration with valid/invalid inputs
- Worker management operations
- Equipment CRUD operations
- Authorization and access control
- Error condition handling

## 🚀 Deployment

### Testnet Deployment
```bash
clarinet deployments generate --testnet
clarinet deployments apply --testnet
```

### Mainnet Deployment
```bash
clarinet deployments generate --mainnet
clarinet deployments apply --mainnet
```

## 📊 Gas Costs

Estimated gas costs for common operations:

| Operation | Estimated Cost |
|-----------|----------------|
| System Activation | ~1,000 µSTX |
| Register Material | ~2,500 µSTX |
| Register Worker | ~2,200 µSTX |
| Register Machine | ~2,800 µSTX |
| Modify Machine | ~3,200 µSTX |
| Inspect Records | ~500 µSTX |

*Costs may vary based on network conditions and input complexity*

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [BuildWise Docs](https://docs.buildwise.construction)
- **Issues**: [GitHub Issues](https://github.com/iamifeoma/BuildWise-Construction/issues)
- **Discord**: [BuildWise Community](https://discord.gg/buildwise)
- **Email**: support@buildwise.construction

## 🗺️ Roadmap

### Phase 1 (Current)
- [x] Core resource management functionality
- [x] Access control and security features
- [x] Comprehensive testing suite

### Phase 2 (Q3 2025)
- [ ] Project management features
- [ ] Cost estimation tools
- [ ] Integration with external APIs
- [ ] Mobile application

### Phase 3 (Q4 2025)
- [ ] Multi-signature support
- [ ] Advanced reporting and analytics
- [ ] Cross-chain compatibility
- [ ] Enterprise features

## 🏆 Acknowledgments

- Built with [Clarity](https://clarity-lang.org/) smart contract language
- Powered by [Stacks](https://www.stacks.co/) blockchain
- Developed with [Clarinet](https://github.com/hirosystems/clarinet) toolkit

---

**BuildWise** - Building the future of construction management on blockchain 🏗️⛓️