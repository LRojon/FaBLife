import React, { useState, useEffect } from 'react';
import './Animations.css';

const PlayerLifeBlock = ({ player, onLifeChange, isTop }) => {
  const [shakeKey, setShakeKey] = useState(0);
  
  const adjustLife = (amount) => {
    const newLife = Math.max(0, player.life + amount);
    
    // Détecter les pertes importantes (5 PV ou plus)
    if (amount <= -5) {
      // Incrémenter la clé pour forcer le redéclenchement
      setShakeKey(prev => prev + 1);
    }
    
    onLifeChange(newLife);
  };

  const getLifeColor = () => {
    return 'text-white';
  };

  const getLifeBarColor = () => {
    if (!player.life || !player.maxLife) {
      return 'from-gray-500 via-gray-400 to-gray-500';
    }
    const percentage = (player.life / player.maxLife) * 100;
    if (percentage > 60) return 'from-emerald-500 via-green-400 to-emerald-600';
    if (percentage > 30) return 'from-amber-500 via-yellow-400 to-orange-500';
    return 'from-red-500 via-red-400 to-red-600';
  };

  // Gestion simplifiée des clics et appuis longs
  const handleButtonInteraction = (amount, event) => {
    // Empêcher les événements multiples
    event.preventDefault();
    event.stopPropagation();
    
    let timeout;
    let interval;
    let hasLongPressed = false;
    let isActive = true;
    
    const startLongPress = () => {
      timeout = setTimeout(() => {
        if (!isActive) return;
        hasLongPressed = true;
        // Après 300ms, commencer l'action répétée avec x5
        const longPressAmount = amount * 5;
        
        interval = setInterval(() => {
          if (!isActive) return;
          adjustLife(longPressAmount);
        }, 150); // Répéter toutes les 150ms
      }, 300);
    };

    const stopLongPress = () => {
      isActive = false;
      clearTimeout(timeout);
      clearInterval(interval);
      
      // Action au relâchement seulement si pas d'appui long
      if (!hasLongPressed) {
        adjustLife(amount);
      }
    };
    
    startLongPress();
    
    // Nettoyer les timers
    const cleanup = () => {
      stopLongPress();
      document.removeEventListener('mouseup', cleanup);
      document.removeEventListener('touchend', cleanup);
      document.removeEventListener('mouseleave', cleanup);
      document.removeEventListener('contextmenu', cleanup);
    };
    
    document.addEventListener('mouseup', cleanup);
    document.addEventListener('touchend', cleanup);
    document.addEventListener('mouseleave', cleanup);
    document.addEventListener('contextmenu', cleanup);
  };

  // Rotation différente selon le joueur : -90° pour le joueur du haut, -90° pour le joueur du bas
  const rotationClass = isTop ? '-rotate-90' : '-rotate-90';

  const lifePercentage = player.life && player.maxLife ? (player.life / player.maxLife) * 100 : 0;

  return (
    <div 
      key={shakeKey}
      className={`flex-1 flex bg-gray-800 ${shakeKey > 0 ? 'shake-animation' : ''}`}
      style={{
        userSelect: 'none',
        WebkitUserSelect: 'none',
        MozUserSelect: 'none',
        msUserSelect: 'none',
        WebkitTouchCallout: 'none',
        touchAction: 'manipulation'
      }}
    >
      {/* Barre de vie sur la gauche - style jeu de combat */}
      <div className="w-12 bg-gray-900 flex flex-col p-2 justify-center items-center">
        <div className="flex flex-col justify-center items-center">
          {/* Conteneur de la barre avec bordure - hauteur fixe */}
          <div className="w-8 h-80 bg-gradient-to-b from-gray-900 to-gray-800 border-2 border-gray-500 rounded-lg shadow-lg overflow-hidden relative">
            {/* Barre de fond (vide) avec texture */}
            <div className="w-full h-full bg-gradient-to-b from-gray-800 to-gray-900 relative">
              {/* Barre de vie remplie avec effet de profondeur */}
              <div 
                className={`w-full bg-gradient-to-t ${getLifeBarColor()} transition-all duration-700 ease-in-out absolute ${isTop ? 'top-0' : 'bottom-0'} shadow-inner`}
                style={{ 
                  height: `${lifePercentage}%`,
                  minHeight: player.life > 0 ? '3px' : '0px',
                  boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.3), inset 0 -1px 0 rgba(255,255,255,0.1)'
                }}
              />
              {/* Effect de brillance (style jeu de combat) avec gradient plus sophistiqué */}
              <div 
                className={`w-full bg-gradient-to-t from-transparent via-white/30 to-transparent absolute ${isTop ? 'top-0' : 'bottom-0'} pointer-events-none transition-all duration-700 ease-in-out`}
                style={{ 
                  height: `${lifePercentage}%`,
                  minHeight: player.life > 0 ? '3px' : '0px'
                }}
              />
              
              {/* Bordure interne pour effet de profondeur */}
              <div className="absolute inset-1 border border-white/10 rounded-md pointer-events-none"></div>
              
              {/* Petits segments pour l'effet "jauges" avec style amélioré */}
              {Array.from({ length: 19 }, (_, i) => (
                <div
                  key={i}
                  className="absolute w-full h-0.5 bg-gradient-to-r from-transparent via-gray-900/80 to-transparent shadow-sm"
                  style={{ [isTop ? 'top' : 'bottom']: `${((i + 1) * 5)}%` }}
                />
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Contenu principal déplacé vers la droite */}
      <div className="flex-1 flex flex-col items-center justify-center p-6">
        {/* Life display and controls in one line - rotated */}
        <div className={`flex items-center gap-8 ${rotationClass}`}>
          {!isTop ? (
            // Joueur 1 (en bas) : ordre normal - + PV +
            <>
              <button
                onPointerDown={(e) => handleButtonInteraction(-1, e)}
                onContextMenu={(e) => e.preventDefault()}
                className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
                style={{ 
                  userSelect: 'none', 
                  touchAction: 'manipulation',
                  WebkitTouchCallout: 'none',
                  WebkitUserSelect: 'none',
                  WebkitTapHighlightColor: 'transparent',
                  WebkitUserDrag: 'none',
                  MozUserSelect: 'none',
                  msUserSelect: 'none'
                }}
              >
                −
              </button>

              <div className={`text-8xl font-bold mx-4 ${getLifeColor()}`}>
                {player.life || 0}
              </div>

              <button
                onPointerDown={(e) => handleButtonInteraction(1, e)}
                onContextMenu={(e) => e.preventDefault()}
                className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
                style={{ 
                  userSelect: 'none', 
                  touchAction: 'manipulation',
                  WebkitTouchCallout: 'none',
                  WebkitUserSelect: 'none',
                  WebkitTapHighlightColor: 'transparent',
                  WebkitUserDrag: 'none',
                  MozUserSelect: 'none',
                  msUserSelect: 'none'
                }}
              >
                +
              </button>
            </>
          ) : (
            // Joueur 2 (en haut) : ordre inversé + PV -
            <>
              <button
                onPointerDown={(e) => handleButtonInteraction(1, e)}
                onContextMenu={(e) => e.preventDefault()}
                className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
                style={{ 
                  userSelect: 'none', 
                  touchAction: 'manipulation',
                  WebkitTouchCallout: 'none',
                  WebkitUserSelect: 'none',
                  WebkitTapHighlightColor: 'transparent',
                  WebkitUserDrag: 'none',
                  MozUserSelect: 'none',
                  msUserSelect: 'none'
                }}
              >
                +
              </button>

              <div className={`text-8xl font-bold mx-4 ${getLifeColor()}`}>
                {player.life || 0}
              </div>

              <button
                onPointerDown={(e) => handleButtonInteraction(-1, e)}
                onContextMenu={(e) => e.preventDefault()}
                className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
                style={{ 
                  userSelect: 'none', 
                  touchAction: 'manipulation',
                  WebkitTouchCallout: 'none',
                  WebkitUserSelect: 'none',
                  WebkitTapHighlightColor: 'transparent',
                  WebkitUserDrag: 'none',
                  MozUserSelect: 'none',
                  msUserSelect: 'none'
                }}
              >
                −
              </button>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default PlayerLifeBlock;