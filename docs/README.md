# VLIW SIMD Documentation Index

**Project Status:** Production Ready — 114/114 tests pass (47 unit + 67 integration)  
**Last Updated:** March 5, 2026

---

## Essential Documentation

### 📖 Start Here
- **[README.md](../README.md)** - Project overview, quick start, and status

### 🏗️ Architecture & Design
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Complete architecture reference
  - Core pipeline and execution engines
  - Memory subsystem design
  - Instruction encoding
  - Configuration system

### 🔧 Development
- **[TOOLCHAIN.md](TOOLCHAIN.md)** - Build, test, and deployment procedures
- **[DRIVER_API.md](DRIVER_API.md)** - C driver API reference (30 functions)

### 🐛 Issues & History
- **[KNOWN_ISSUES.md](KNOWN_ISSUES.md)** - Known limitations and workarounds
- **[CHANGELOG.md](CHANGELOG.md)** - Development history (Phases 0-5 + load-use hazard sweep)

---

## Quick Navigation

### For New Users
1. Read [README.md](../README.md) for project overview
2. Check [TOOLCHAIN.md](TOOLCHAIN.md) for build instructions
3. Run baseline verification to confirm setup

### For Developers
1. Study [ARCHITECTURE.md](ARCHITECTURE.md) for design details
2. Review [KNOWN_ISSUES.md](KNOWN_ISSUES.md) for limitations
3. Consult [DRIVER_API.md](DRIVER_API.md) for integration

### For Debugging
1. Check [KNOWN_ISSUES.md](KNOWN_ISSUES.md) for known problems
2. Review [CHANGELOG.md](CHANGELOG.md) for recent changes
3. See [ARCHITECTURE.md](ARCHITECTURE.md) for module details

---

## Document Summary

| Document | Lines | Purpose |
|----------|-------|---------|
| ARCHITECTURE.md | ~500 | Complete technical reference (incl. load-use hazard detection) |
| CHANGELOG.md | ~420 | Development history (Phases 0-5 + hazard sweep) |
| KNOWN_ISSUES.md | ~300 | Issue tracking and workarounds |
| DRIVER_API.md | ~200 | C API reference |
| TOOLCHAIN.md | ~810 | Build, test, and toolchain reference |

---

## Documentation Standards

### Status Indicators
- ✅ **Production Ready** - Verified and stable
- ⚠️ **Known Issue** - Documented limitation
- ⏳ **Not Tested** - Pending verification
- 🔧 **In Progress** - Under development

### Version Information
All documents include:
- Last updated date
- Current phase/version
- Status indicators

---

## Maintenance

**Update Frequency:** After each major change or phase completion  
**Review Cycle:** Monthly for accuracy  
**Consolidation:** Completed February 21, 2026

---

## Additional Resources

### Source Code
- `src/main/scala/vliw/` - RTL implementation (SpinalHDL)
- `tools/` - Assembler and scheduler
- `verification/` - Test infrastructure

### Generated Content
- `generated_rtl/` - Verilog output from RTL generation
- `verification/cocotb/integration/sim_build/` - Simulation artifacts

---

**For questions or issues, refer to project maintainers.**
