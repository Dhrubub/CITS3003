varying vec4 Position;
varying vec3 Normal;
varying vec2 texCoord;

vec4 color;

uniform sampler2D texture;

// PART G. Added variables for fragment lighting
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView;
uniform mat4 Projection;
uniform float Shininess;

uniform float texScale; // PART 2A. Texture scale variable

// Light Object 1
uniform vec4 LightPosition;
uniform vec3 LightColor;
uniform float LightBrightness;
uniform vec4 LightObj; // PART J. Location of light 1

// PART I. Light Object 2
uniform vec4 LightPosition2;
uniform vec3 LightColor2;
uniform float LightBrightness2;
uniform vec4 LightObj2; // PART J. Location of light 2



void main() {
    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * position).xyz;

    // The vector to the light from the vertex
    vec3 Lvec = LightPosition.xyz - pos;
    // The vector to the origin from the light 2
    vec3 Lvec2 = LightPosition2.xyz;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize(Lvec);   // Direction to the light source
    vec3 L2 = normalize(Lvec2); // Direction to the origin from light 2
    vec3 E = normalize(-pos);   // Direction to the eye/camera
    vec3 H = normalize(L + E);  // Halfway vector
    vec3 H2 = normalize(L2 + E); // Halfway vector for light 2

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize((ModelView*vec4(normal, 0.0)).xyz);

    // Compute terms in the illumination equation
    vec3 ambient = (LightColor * LightBrightness) * AmbientProduct; // Light 1 ambient
    vec3 ambient2 = (LightColor2 * LightBrightness2) * AmbientProduct; // Light 2 ambient

    float Kd = max(dot(L, N), 0.0);
    vec3 diffuse = Kd * (LightColor * LightBrightness) * DiffuseProduct; // Light 1 diffuse
    float Kd2 = max(dot(L2, N), 0.0);
    vec3 diffuse2 = Kd2 * (LightColor2 * LightBrightness2) * DiffuseProduct; // Light 2 diffuse

    float Ks = pow(max(dot(N, H), 0.0), Shininess);
    vec3 specular = Ks * LightBrightness * SpecularProduct; // Light 1 specular
    float Ks2 = pow(max(dot(N, H2), 0.0), Shininess);
    vec3 specular2 = Ks2 * LightBrightness2 * SpecularProduct; // Light 2 specular

    if (dot(L, N) < 0.0) {
        specular = vec3(0.0, 0.0, 0.0);
    }

    if (dot(L2, N) < 0.0) {
        specular2 = vec3(0.0, 0.0, 0.0);
    }

    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.1, 0.1, 0.1);

    // PART F. Reduction in light after a particular distance
    float lightDropoff = 0.01 + length(Lvec);

    color.rgb = globalAmbient + ((ambient + diffuse) / lightDropoff) + ambient2 + diffuse2;
    color.a = 1.0;

    gl_FragColor = (color * texture2D(texture, texCoord * 2.0 * texScale)) + vec4(specular / lightDropoff + specular2, 1.0);
    // PART 2A. Multiply by texScale value

    // PART J. Checking for light under the surface
    if (LightObj.y < 0.0 && LightObj2.y < 0.0) {
        color.rgb = globalAmbient;
        gl_FragColor = color * texture2D(texture, texCoord * 2.0 * texScale);
    } else if (LightObj.y < 0.0) {
        color.rgb = globalAmbient + (ambient2 + diffuse2);
        gl_FragColor = (color * texture2D(texture, texCoord * 2.0 * texScale)) + vec4(specular2, 1.0);
    } else if (LightObj2.y < 0.0) {
        color.rgb = globalAmbient + ((ambient + diffuse) / lightDropoff);
        gl_FragColor = (color * texture2D(texture, texCoord * 2.0 * texScale)) + vec4(specular / lightDropoff, 1.0);
    }
}