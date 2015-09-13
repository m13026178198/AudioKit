//
//  AKDecimator.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/13/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Otherwise known as a "bitcrusher", Decimator will digitially degrade a signal.

Otherwise known as a "bitcrusher", Decimator will digitally degrade a signal.
*/
@objc class AKDecimator : AKParameter {

    // MARK: - Properties

    private var decimator = UnsafeMutablePointer<sp_decimator>.alloc(1)

    private var input = AKParameter()


    /** The bit depth of signal output. Typically in range (1-24). Non-integer values are OK. [Default Value: 8] */
    var bitDepth: AKParameter = akp(8) {
        didSet {
            bitDepth.bind(&decimator.memory.bit)
            dependencies.append(bitDepth)
        }
    }

    /** The sample rate of signal output. [Default Value: 10000] */
    var sampleRate: AKParameter = akp(10000) {
        didSet {
            sampleRate.bind(&decimator.memory.srate)
            dependencies.append(sampleRate)
        }
    }


    // MARK: - Initializers

    /** Instantiates the decimator with default values */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        dependencies = [input]
        bindAll()
    }

    /**
    Instantiates the decimator with all values

    - parameter input: Input audio signal. 
    - parameter bitDepth: The bit depth of signal output. Typically in range (1-24). Non-integer values are OK. [Default Value: 8]
    - parameter sampleRate: The sample rate of signal output. [Default Value: 10000]
    */
    convenience init(
        input      sourceInput: AKParameter,
        bitDepth   bitInput:    AKParameter,
        sampleRate srateInput:  AKParameter)
    {
        self.init(input: sourceInput)
        bitDepth   = bitInput
        sampleRate = srateInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal decimator */
    internal func bindAll() {
        bitDepth  .bind(&decimator.memory.bit)
        sampleRate.bind(&decimator.memory.srate)
        dependencies.append(bitDepth)
        dependencies.append(sampleRate)
    }

    /** Internal set up function */
    internal func setup() {
        sp_decimator_create(&decimator)
        sp_decimator_init(AKManager.sharedManager.data, decimator)
    }

    /** Computation of the next value */
    override func compute() {
        sp_decimator_compute(AKManager.sharedManager.data, decimator, &(input.leftOutput), &leftOutput);
        sp_decimator_compute(AKManager.sharedManager.data, decimator, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_decimator_destroy(&decimator)
    }
}
