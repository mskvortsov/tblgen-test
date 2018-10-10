#include <assert.h>
#include <iostream>

namespace llvm {

void llvm_unreachable(const char *msg) {
  assert(0 && msg);
}

#define LLVM_DEBUG(x) x

std::ostream &errs() { return std::cerr; }
std::ostream &dbgs() { return std::cerr; }

namespace MCD {
enum {
  OPC_ExtractField = 0,
  OPC_FilterValue,
  OPC_CheckField,
  OPC_CheckPredicate,
  OPC_TryDecode,
  OPC_Decode,
  OPC_SoftFail,
  OPC_Fail,
};
}

class FeatureBitset {
};

class MCSubtargetInfo {
public:
  const FeatureBitset getFeatureBits() const {
    return FeatureBitset();
  }
};

class MCDisassembler {
public:
  enum DecodeStatus {
    Success = 0,
    SoftFail,
    Fail
  };
};

class MCOperand {
public:
  static MCOperand &createReg(unsigned Reg) { }
  static MCOperand &createImm(unsigned Imm) { }
};

class MCInst {
  unsigned Opcode;
public:
  void setOpcode(unsigned Opc) { Opcode = Opc; }
  unsigned getOpcode() { return Opcode; }
  void addOperand(const MCOperand &MO) { }
  void clear() { }
};

} // namespace llvm

using namespace llvm;

typedef MCDisassembler::DecodeStatus DecodeStatus;

static DecodeStatus DecodeGPRexcl3RegisterClass(MCInst &MI, uint64_t RegNo,
                                            uint64_t Address,
                                            const void *Decoder) {
  MI.addOperand(MCOperand::createReg(RegNo));
  return DecodeStatus::Success;
}

#define GET_INSTRINFO_ENUM
#include "TestInstrInfo.inc"
#include "TestDisasm.inc"

int main() {
  MCInst MI;
  MCSubtargetInfo STI;

  unsigned Insn = 0x430f; // mov #0, r3
  DecodeStatus Res = decodeInstruction(DecoderTable16, MI, Insn, 0, 0, STI);

  assert(Res == DecodeStatus::Success && "Decoding failed");
  assert(MI.getOpcode() == Test::MOV16rc && "Expected MOV16rc");

  return 0;
}
