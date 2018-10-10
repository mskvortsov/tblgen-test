LLVMINC=~/llvm/include
TBLGEN=~/llvm-build/bin/llvm-tblgen
CXX=g++

Test: TestInstrInfo.inc TestDisasm.inc Test.cpp
	$(CXX) -O2 -o Test Test.cpp

TestDisasm.inc: Test.td
	$(TBLGEN) -gen-disassembler -I $(LLVMINC) $< -o $@

TestInstrInfo.inc: Test.td
	$(TBLGEN) -gen-instr-info -I $(LLVMINC) $< -o $@

clean:
	rm -f *.inc Test
