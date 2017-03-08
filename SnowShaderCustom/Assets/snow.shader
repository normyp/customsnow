Shader "Custom/snow" {
	Properties {
		_Color ("Snow Colour", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump ("Bump surface", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Bump;

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float3 worldNormal;
			INTERNAL_DATA
		};

		fixed4 _Color;

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
