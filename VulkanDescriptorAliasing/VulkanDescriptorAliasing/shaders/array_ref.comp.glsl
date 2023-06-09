#version 450

#define ARRAY_SIZE      8U

layout(local_size_x = 1024, local_size_y = 1, local_size_z = 1) in;

layout(std430, set = 0, binding = 0) buffer writeonly Dst {
    int dstBuffer[];
};

layout(std430, set = 0, binding = 1) buffer readonly Src {
    int srcBuffer[];
};

void main(void)
{
    const int arrayA[ARRAY_SIZE] = { 1, 1, 1, 1, 1, 1, 1, 1 };
    const int arrayB[ARRAY_SIZE] = { 2, 2, 2, 2, 2, 2, 2, 2 };

    const uint gid = gl_GlobalInvocationID.x;

    int refArray[ARRAY_SIZE];
    if ((gid & 1) == 0) {
        refArray = arrayA;
    }
    else {
        refArray = arrayB;
    }

    int sum = 0;
    for (uint i = 0; i < ARRAY_SIZE; ++i) {
        sum += refArray[i];
    }

    dstBuffer[gid] = srcBuffer[gid] + sum;
}

/**
 * ======== The following GLSL code is generated by disassembling the output array_ref.spv ========
 * 
    void main()
    {
        int refArray[8];
        if ((gl_GlobalInvocationID.x & 1u) == 0u)
        {
            refArray = int[](1, 1, 1, 1, 1, 1, 1, 1);
        }
        else
        {
            refArray = int[](2, 2, 2, 2, 2, 2, 2, 2);
        }
        int _70;
        _70 = 0;
        for (uint _69 = 0u; _69 < 8u; )
        {
            _70 += refArray[_69];
            _69++;
            continue;
        }
        _54.dstBuffer[gl_GlobalInvocationID.x] = _59.srcBuffer[gl_GlobalInvocationID.x] + _70;
    }
 * 
*/

