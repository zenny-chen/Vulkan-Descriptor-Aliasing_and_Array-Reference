#version 450
#extension GL_EXT_shader_explicit_arithmetic_types : enable
#extension GL_EXT_shader_explicit_arithmetic_types_int8 : enable

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

layout(std430, set = 0, binding = 0) buffer writeonly Dst {
    int dstBuffer[];
};

layout(std430, set = 0, binding = 1) buffer readonly Src1 {
    int src1Buffer[];
};
// Here is the same binding as Src1 and so refers to the same device buffer as Src1
// This is the descriptor-aliasing functionality
layout(std430, set = 0, binding = 1) buffer readonly Src2 {
    uint8_t src2Buffer[];
};

void main(void)
{
    const uint gid = gl_GlobalInvocationID.x;

    const uint src2Value = uint(src2Buffer[gid]);
    dstBuffer[gid] = src1Buffer[gid] + int(src2Value);
}

