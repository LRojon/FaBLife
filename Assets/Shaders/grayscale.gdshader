shader_type canvas_item;

// Crée un curseur dans l'inspecteur variant de 0.0 à 1.0
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    // Récupère la couleur originale de la texture
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Calcule la luminosité en nuances de gris
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Crée la couleur grise finale (conserve l'alpha)
    vec4 gray_color = vec4(vec3(gray), tex_color.a);
    
    // Alterne (mixe) entre la couleur d'origine et la couleur grise selon l'intensité
    COLOR = mix(tex_color, gray_color, intensity);
}
