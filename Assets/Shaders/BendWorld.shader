Shader "Unlit/BendWorld"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			// bend world - begin
			#pragma multi_compile __ BEND_ON
			#pragma multi_compile __ BEND_OFF
			// bend world - end
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			// bend world - begin
			uniform float _HORIZON = 0.0f;
			uniform float _ATTENUATE = 0.0f;
			uniform float _SPREAD = 0.0f;

			float4 DSEffect(float4 v)
			{
				float4 t = mul(unity_ObjectToWorld, v);
				float dist = max(0, abs(_HORIZON - t.z) - _SPREAD);
				t.y -= dist * dist * _ATTENUATE;
				t.xyz = mul(unity_WorldToObject, t).xyz * 1.0;
				return t;
			}
			// bend world - end


			v2f vert(appdata_full v)
			{
				v2f o;
				// bend world - begin
				#if defined(BEND_OFF)
					o.vertex = UnityObjectToClipPos(v.vertex);
				#else
					#if defined(BEND_ON)
						o.vertex = UnityObjectToClipPos(DSEffect(v.vertex));
					#else
						o.vertex = UnityObjectToClipPos(v.vertex);
					#endif
				#endif
				// bend world - end
				
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				
				UNITY_TRANSFER_FOG(o, o.vertex);

				return o;
			}
			
			/*v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}*/
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
