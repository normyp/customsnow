Shader "Custom/snow" {
	Properties {
		_Color ("Snow Colour", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			INTERNAL_DATA
		};

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			float4 vertical = float4(0.0, 1.0, 0.0, 1.0);
			float angle = dot(IN.worldNormal, vertical.xyz);

			float4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color * angle;
			o.Albedo = c.rgb;
			//o.Normal = IN.worldNormal;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
