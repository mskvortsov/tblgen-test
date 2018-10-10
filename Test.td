include "llvm/Target/Target.td"

class Reg<bits<4> num, string n> : Register<n> {
  field bits<4> Num = num;
  let HWEncoding{3-0} = num;
}

def R0  : Reg<0,  "r0">;
def R1  : Reg<1,  "r1">;
def R2  : Reg<2,  "r2">;
def R3  : Reg<3,  "r3">;
def R4  : Reg<4,  "r4">;
def R5  : Reg<5,  "r5">;
def R6  : Reg<6,  "r6">;
def R7  : Reg<7,  "r7">;
def R8  : Reg<8,  "r8">;
def R9  : Reg<9,  "r9">;
def R10 : Reg<10, "r10">;
def R11 : Reg<11, "r11">;
def R12 : Reg<12, "r12">;
def R13 : Reg<13, "r13">;
def R14 : Reg<14, "r14">;
def R15 : Reg<15, "r15">;

def GPRexcl023 : RegisterClass<"Test", [i16], 16, (add R1, (sequence "R%u", 4, 15))>;
def GPRexcl3   : RegisterClass<"Test", [i16], 16, (add R0, R1, R2, (sequence "R%u", 4, 15))>;
def GPR        : RegisterClass<"Test", [i16], 16, (sequence "R%u", 0, 15)>;

def CGImmAsmOperand : AsmOperandClass {
  let Name = "CGImm";
  let RenderMethod = "addImmOperands";
}

def cgimm : Operand<i16>,
            ImmLeaf<i16, [{ return Imm == 0 || Imm == 1 || Imm == 2 ||
                                   Imm == 4 || Imm == 8 || Imm == -1; }]> {
  let ParserMatchClass = CGImmAsmOperand;
  let EncoderMethod = "getCGImmOpValue";
}

class TestInst<dag outs, dag ins, string asmstr> : Instruction {
  field bits<16> Inst;
  field bits<16> SoftFail = 0;

  let Namespace = "Test";

  dag OutOperandList = outs;
  dag InOperandList  = ins;

  let AsmString = asmstr;
  let Size = 2;
}

def MOV16rr : TestInst<(outs GPRexcl3:$rd), (ins GPRexcl3:$rs),
                       "mov $rs, $rd"> {
  bits<4> rs;
  bits<4> rd;

  let Inst{15-12} = 0b0100; // Opcode
  let Inst{11-8} = rs;      // Rs
  let Inst{7-4} = 0b0000;   // Ad, Bw, As
  let Inst{3-0} = rd;       // Rd
}

def MOV16rc : TestInst<(outs GPRexcl3:$rd), (ins cgimm:$imm),
                       "mov $imm, $rd"> {
  bits<3> imm;
  bits<4> rd;

  let Inst{15-12} = 0b0100; // Opcode
  let Inst{11-9} = 0b001;   // Rs
  let Inst{8} = imm{0};     // Rs
  let Inst{7-6} = 0b00;     // Ad, Bw
  let Inst{5-4} = imm{2-1}; // As
  let Inst{3-0} = rd;       // Rd
}

def TestInstrInfo : InstrInfo;

def Test : Target {
  let InstructionSet = TestInstrInfo;
}
