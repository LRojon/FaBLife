import React, { useState, useRef } from 'react';

const Life = ({ pv, cumul, onLifeChange, isPlayer1 }) => {
  const [displayCumul, setDisplayCumul] = useState(null);
  const cumulTimeoutRef = useRef(null);
  const applyTimeoutRef = useRef(null);
  const longPressTimeoutRef = useRef(null);
  const longPressIntervalRef = useRef(null);
  const isLongPressingRef = useRef(false);
  const accumulatedRef = useRef(0);

  const showCumul = (value, duration = 300) => {
    setDisplayCumul(value);
    if (cumulTimeoutRef.current) clearTimeout(cumulTimeoutRef.current);
    cumulTimeoutRef.current = setTimeout(() => {
      setDisplayCumul(null);
    }, duration);
  };

  const applyAccumulated = () => {
    if (accumulatedRef.current !== 0) {
      onLifeChange(accumulatedRef.current);
      accumulatedRef.current = 0;
    }
  };

  const handleButtonInteraction = (amount, event) => {
    event.preventDefault();
    event.stopPropagation();
    
    isLongPressingRef.current = false;
    let isSimpleClick = true;

    const handlePointerUp = () => {
      // Arrêter les timers
      if (longPressTimeoutRef.current) clearTimeout(longPressTimeoutRef.current);
      if (longPressIntervalRef.current) clearInterval(longPressIntervalRef.current);
      
      if (isLongPressingRef.current) {
        // C'était un long press
        isLongPressingRef.current = false;
        
        // Le cumul du long press est déjà accumulé, on le garde
        // Réinitialiser le timer d'application pour permettre d'autres interactions
        if (applyTimeoutRef.current) clearTimeout(applyTimeoutRef.current);
        applyTimeoutRef.current = setTimeout(() => {
          applyAccumulated();
        }, 500); // Attendre 500ms après la fin du long press
        
      } else if (isSimpleClick) {
        // C'était un simple clic, l'ajouter au cumul existant
        accumulatedRef.current += amount;
        showCumul(accumulatedRef.current, 1000);
        
        // Réinitialiser le timer d'application du cumul
        if (applyTimeoutRef.current) clearTimeout(applyTimeoutRef.current);
        applyTimeoutRef.current = setTimeout(() => {
          applyAccumulated();
        }, 1000);
      }
      
      isSimpleClick = false;
      
      // Nettoyer les listeners
      document.removeEventListener('pointerup', handlePointerUp);
      document.removeEventListener('pointercancel', handlePointerUp);
    };

    // Démarrer le timer pour le long press
    longPressTimeoutRef.current = setTimeout(() => {
      if (!isLongPressingRef.current) {
        isLongPressingRef.current = true;
        isSimpleClick = false;
        
        // Annuler le timer d'application du simple clic si un long press démarre
        if (applyTimeoutRef.current) {
          clearTimeout(applyTimeoutRef.current);
          applyTimeoutRef.current = null;
        }
        
        const longPressAmount = amount * 5;
        
        // Appliquer le premier ±5 immédiatement
        accumulatedRef.current += longPressAmount;
        showCumul(accumulatedRef.current, 1000);

        // Boucle du long press pour les suivants
        longPressIntervalRef.current = setInterval(() => {
          accumulatedRef.current += longPressAmount;
          showCumul(accumulatedRef.current, 1000);
        }, 500);
      }
    }, 300);

    // Listener pour arrêter le long press
    document.addEventListener('pointerup', handlePointerUp);
    document.addEventListener('pointercancel', handlePointerUp);
  };

  return (
    <div 
      className="w-full h-full flex flex-col items-center justify-center p-6 relative md:h-full"
      style={{
        userSelect: 'none',
        WebkitUserSelect: 'none',
        MozUserSelect: 'none',
        msUserSelect: 'none',
        WebkitTouchCallout: 'none',
        touchAction: 'manipulation'
      }}
    >
      {/* Affichage du cumul */}
      {displayCumul !== null && (
        <div 
          className={`absolute text-3xl font-bold ${
            displayCumul > 0 ? 'text-green-400' : 'text-red-400'
          }`}
          style={{
            top: '20%',
            left: '50%',
            transform: 'translateX(-50%)',
            textShadow: '2px 2px 4px rgba(0,0,0,0.8)',
            zIndex: 10
          }}
        >
          {displayCumul > 0 ? '+' : ''}{displayCumul}
        </div>
      )}
      
      <div className="flex items-center gap-8">
        {isPlayer1 ? (
          // Player 1: - PV +
          <>
            <button
              onPointerDown={(e) => handleButtonInteraction(-1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 font-black select-none transition-colors cursor-pointer"
              style={{ 
                fontSize: 'clamp(3rem, 15vw, 12rem)',
                userSelect: 'none', 
                touchAction: 'manipulation',
                WebkitTouchCallout: 'none',
                WebkitUserSelect: 'none',
                WebkitTapHighlightColor: 'transparent'
              }}
            >
              −
            </button>
            <div 
              className="font-bold mx-4 text-white text-center"
              style={{
                fontSize: 'clamp(4rem, 20vw, 16rem)',
                userSelect: 'none',
                WebkitUserSelect: 'none'
              }}
            >
              {pv || 0}
            </div>
            <button
              onPointerDown={(e) => handleButtonInteraction(1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 font-black select-none transition-colors cursor-pointer"
              style={{ 
                fontSize: 'clamp(3rem, 15vw, 12rem)',
                userSelect: 'none', 
                touchAction: 'manipulation',
                WebkitTouchCallout: 'none',
                WebkitUserSelect: 'none',
                WebkitTapHighlightColor: 'transparent'
              }}
            >
              +
            </button>
          </>
        ) : (
          // Player 2: + PV -
          <>
            <button
              onPointerDown={(e) => handleButtonInteraction(1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 font-black select-none transition-colors cursor-pointer"
              style={{ 
                fontSize: 'clamp(3rem, 15vw, 12rem)',
                userSelect: 'none', 
                touchAction: 'manipulation',
                WebkitTouchCallout: 'none',
                WebkitUserSelect: 'none',
                WebkitTapHighlightColor: 'transparent'
              }}
            >
              +
            </button>
            <div 
              className="font-bold mx-4 text-white text-center"
              style={{
                fontSize: 'clamp(4rem, 20vw, 16rem)',
                userSelect: 'none',
                WebkitUserSelect: 'none'
              }}
            >
              {pv || 0}
            </div>
            <button
              onPointerDown={(e) => handleButtonInteraction(-1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 font-black select-none transition-colors cursor-pointer"
              style={{ 
                fontSize: 'clamp(3rem, 15vw, 12rem)',
                userSelect: 'none', 
                touchAction: 'manipulation',
                WebkitTouchCallout: 'none',
                WebkitUserSelect: 'none',
                WebkitTapHighlightColor: 'transparent'
              }}
            >
              −
            </button>
          </>
        )}
      </div>
    </div>
  );
};

export default Life;