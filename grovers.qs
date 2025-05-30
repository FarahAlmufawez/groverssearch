namespace Grovers {
    import Std.Arrays.ForEach;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Unstable.Arithmetic;
    open Microsoft.Quantum.ResourceEstimation;

     
    @EntryPoint()
    operation RunProgram() : Result[] {
       return SixGroverRun(6, [true,false,true,false,true,false]);
        
    }

    operation GateSwitch(target: Qubit[], pattern: Bool[]) : Unit {
        for i in 0..Length(pattern) - 1 {
            if pattern[i] {
                X(target[i]); 
            }
        }     
    }

    operation SelectorSix(target: Qubit[], pattern: Bool[]) : Unit {
        GateSwitch(target, pattern); 
        Controlled Z(target[0..4],target[5]); 
        GateSwitch(target, pattern); 
    }
operation AmplifySix(target: Qubit[]) : Unit {
 // step 1 : apply hadamard and puli-x gate to each qubit 
   for i in 0..5 {
    H(target[i]);
    X(target[i]);
   }

 // step 2 : apply controlled-Z with the last qubit as the target
   Controlled Z(target[0..4],target[5]);

 // step 4 : apply puli-x and hadamard gate to each qubit 
   for i in 0..5 {
    X(target[i]);
    H(target[i]);
   }
 
}
operation SixQGroverIteration(target: Qubit[], pattern: Bool[]) : Unit {
    // step 1: apply the selector to select the targe state 
    SelectorSix(target,pattern);
    
    // step 2 : apply the amplifier to boost the probability of the slected state 
    AmplifySix(target);

    
        
}
operation SixQGrovers(target: Qubit[], pattern: Bool[], repeats: Int) : Unit {
    // This operation performs multiple iterations a 6-qubit array.

    for i in 0..repeats-1{
        SixQGroverIteration(target,pattern);
    }
       
    
}
operation RandomiseSix(target: Qubit[]) : Unit {

    for X in 0..5 {
      H(target[X])     
    } 
    
}
    operation SixGroverRun(repeats: Int, pattern: Bool[]) : Result[] {
        use q = Qubit[6];
        RandomiseSix(q);
        SixQGrovers(q, pattern, repeats);
        //DumpMachine();
        //ResetAll(q);
        return MResetEachZ(q); 
    }
}
