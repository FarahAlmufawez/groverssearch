/// # Sample
/// Estimating Frequency for Shor's algorithm
///
/// # Description
/// In this sample we concentrate on costing the `EstimateFrequency`
/// operation, which is the core quantum operation in Shor's algorithm, and
/// we omit the classical pre- and post-processing. This makes it ideal for
/// use with the Azure Quantum Resource Estimator.
namespace grovers{
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
    operation RunProgram() : Unit {
    let pattern : Bool[] = [true, false, true, false, true, false];
    let repeats : Int = 6;
    SixGroverRun(repeats, pattern);
}
    operation GateSwitch(target: Qubit[], pattern: Bool[]) : Unit {
    // loop through each qubit and apply Puli-X gate if paterrn is true
    for i in 0..5 {
        if (pattern[i]){
            X(target[i]);
        }
    }
    
}
operation SelectorSix(target: Qubit[], pattern: Bool[]) : Unit {
    //step 1 : apply Gateswich which represent puli-X
    GateSwitch(target,pattern);
    //step 2 : apply controlled z in all qubit controlling tha last one 
    Controlled Z(target[0..4],target[5]);
    //step 3 : apply Gateswich to get the orginal state
    GateSwitch(target,pattern)
    
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
operation SixGroverRun(repeats: Int, pattern: Bool[]) : Unit {
    use q = Qubit[6];
    RandomiseSix(q);
    SixQGrovers(q, pattern, repeats);
 let measured = ForEach(MResetZ, q);
 Message($"Measured result: {measured}");
      
}
}