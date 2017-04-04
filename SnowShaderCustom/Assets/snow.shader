// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/snow" {
	Properties {
		_Color ("Snow Colour", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump ("Bump surface", 2D) = "bump" {}
		_Z ("Z", Range(0, 10)) = 0.2
		_Depth ("Depth", Range(0, 100)) = 0.2
		_SnowLevel ("Snow Level", Range(0, 1)) = 0.01
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;
		float _Z;
		float _Depth;
		float _SnowLevel;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
		};

		fixed4 _Color;

		void vert(inout appdata_full v) {
			float timeDepth = _Time.y;
			if(timeDepth < 20.0f) {
				timeDepth = _Time.y;
			}
			else {
				timeDepth = 20.0f;
			}
			float4 objVertical = mul(float4(0.0, _Depth + timeDepth, 0.0, 1.0), unity_WorldToObject);
			float angle = dot(v.normal, objVertical.xyz);
			if (angle > 0.8) {
				v.vertex.xyz += (objVertical + v.normal) * angle * _SnowLevel + _Z;
			}
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//Set the out normal to the normal of the bump surface
			o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));

			//Set the albedo and alpha based on the direction of the normal
			float4 vertical = float4(0.0, 1.0, 0.0, 1.0);
			float angle = dot(WorldNormalVector(IN, o.Normal), vertical.xyz);
			float4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color * angle;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
