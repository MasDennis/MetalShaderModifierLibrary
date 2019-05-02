# MetalShaderModifierLibrary

How `SCNProgram`'s `handleBinding()` method can be used with Metal:

First define a data structure in your `.metal` shader file:

```
struct MyShaderUniforms {
	float myFloatParam;
	float2 myFloat2Param;
}
```

Then pass this as an argument to a shader function:

``` 
fragment half4 myFragmentFunction(MyVertex vertexIn [[stage_in]], constant MyShaderUniforms& shaderUniforms [[buffer(0)]]) {
	...
}
```

Next, define the same data structure in your Swift file:

```
struct MyShaderUniforms {
	var myFloatParam: Float = 1.0
	var myFloat2Param: simd_float2 = simd_float2()
}
```

Now create an instance of this data structure, changes its values and define the `SCNBufferBindingBlock`:

```
var myUniforms = MyShaderUniforms()
myUniforms.myFloatParam = 3.0

...

program.handleBinding(ofBufferNamed: "shaderUniforms", frequency: .perFrame) { (bufferStream, node, shadable, renderer) in
	bufferStream.writeBytes(&myUniforms, count: MemoryLayout<MyShaderUniforms>.stride)
}
```

Here, the string passed to `ofBufferNamed:` corresponds to the argument name in the fragment function. The block's `bufferStream` property then contains the user-defined data type `MyShaderUniforms` which can then be written to with updated values.
