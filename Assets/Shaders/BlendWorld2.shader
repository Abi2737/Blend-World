Shader "Unlit/BlendWorld2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlendY("BlendY", Float) = 0.00
		_BlendX("BlendX", Float) = 0.00
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert addshadow

		uniform sampler2D _MainTex;
		uniform float _BlendY;
		uniform float _BlendX;

		struct Input
		{
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{
			float4 worldSpace = mul(unity_ObjectToWorld, v.vertex);
			worldSpace.xyz -= _WorldSpaceCameraPos.xyz;

			float zz = worldSpace.z * worldSpace.z;
			worldSpace = float4(zz * _BlendX, zz * _BlendY, 0.0f, 0.0f);

			v.vertex += mul(unity_WorldToObject, worldSpace);
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a; 
		}

		ENDCG
	}
}
