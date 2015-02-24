﻿float4 HDREncode(float3 col)
{
	return float4(col, 1) / max(max(1.0, col.r), max(col.g, col.b));
}

float3 HDRDecode(float4 col)
{
	return col.rgb / col.a;
}

float2 EncodeNormal(float3 n)
{
	float2 p = n.xy / (abs(n.z) + 1.0);

	float d = max(abs(p.x) + abs (p.y), EPSILON);
	float r = length(p);
	float2 q = p * r / d;

	float z_is_negative = max(-sign(n.z), 0.0);
	float2 q_sign = sign(sign(q) + 0.5);

	q -= z_is_negative * (dot(q, q_sign) - 1.0) * q_sign;

	return q * 0.5 + 0.5;
}

float3 DecodeNormal(float2 enc)
{
	float2 p = enc * 2.0 - 1.0;

	float zsign = sign(1.0 - abs(p.x) - abs(p.y));
	float z_is_negative = max(-zsign, 0.0);
	float2 p_sign = sign(sign(p) + 0.5);

	p -= z_is_negative * (dot(p, p_sign) - 1.0) * p_sign;

	float r = abs(p.x) + abs(p.y);
	float d = max(length(p), EPSILON);
	float2 q = p * r / d;

	float den = 2.0 / (dot (q, q) + 1.0);

	return float3(den * q, zsign * (den - 1.0));
}

float2 MotionVector(float4 pos, float4 prv)
{
	float2 a = pos.xy / pos.w;
	float2 b = prv.xy / prv.w;

	return ((a - b) * 0.5) + 0.5;
}