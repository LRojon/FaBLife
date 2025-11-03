import React, { useState, useRef, useEffect } from 'react';

const Life = ({ pv, cumul, onLifeChange, isPlayer1 }) => {
  const [displayCumul, setDisplayCumul] = useState(0);
  const [showCumul, setShowCumul] = useState(false);
  const [pendingChanges, setPendingChanges] = useState(0); // Cumul des changements en attente
  const timeoutRef = useRef(null);
  const isProcessingRef = useRef(false); // Pour éviter les événements en double

  // Nettoyer le timeout lors du démontage du composant
  useEffect(() => {
    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, []);

  const adjustLife = (amount) => {
    const currentPV = pv || 0;
    const newLife = Math.max(0, currentPV + amount);
    const actualChange = newLife - currentPV;
    
    // Seulement si les PV ont vraiment changé
    if (actualChange !== 0) {
      // Mettre à jour l'affichage du cumul
      setDisplayCumul(prev => prev + actualChange);
      
      // Ajouter le changement aux changements en attente
      setPendingChanges(prev => prev + actualChange);
      
      setShowCumul(true);
      
      // Annuler le timer précédent s'il existe
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
      
      // Nouveau timer de 800ms - quand il expire, appliquer TOUS les changements
      timeoutRef.current = setTimeout(() => {
        // Appliquer le total des changements accumulés
        setPendingChanges(currentPending => {
          if (currentPending !== 0) {
            onLifeChange(currentPending);
          }
          return 0; // Reset les changements en attente
        });
        
        setShowCumul(false);
        setDisplayCumul(0);
        timeoutRef.current = null;
      }, 800);
      
      return true; // Indique que le changement a eu lieu
    }
    
    return false; // Indique qu'aucun changement n'a eu lieu
  };

  const handleButtonInteraction = (amount, event) => {
    // Éviter les événements en double
    if (isProcessingRef.current) {
      return;
    }
    
    // Éviter les événements multiples du même type
    const eventKey = `${amount}_${Date.now()}`;
    if (window.lastEventKey === eventKey) {
      return;
    }
    window.lastEventKey = eventKey;
    
    isProcessingRef.current = true;
    event.preventDefault();
    event.stopPropagation();
    
    let longPressTimer;
    let repeatTimer;
    let hasLongPressed = false;
    let isActive = true;
    
    // NE PAS faire d'action immédiate - attendre de voir si c'est un appui long
    
    // Démarrer le timer pour l'appui long
    longPressTimer = setTimeout(() => {
      if (!isActive) return;
      hasLongPressed = true;
      
      // Premier trigger d'appui long
      const longPressAmount = amount * 5;
      adjustLife(longPressAmount);
      
      // Répéter l'action toutes les 400ms
      repeatTimer = setInterval(() => {
        if (!isActive) return;
        
        const success = adjustLife(longPressAmount);
        if (!success) {
          isActive = false;
          clearInterval(repeatTimer);
        }
      }, 400); // Délai de 400ms entre les triggers
    }, 300); // Attendre 300ms pour détecter l'appui long
    
    const stopInteraction = (e) => {
      if (e) {
        e.preventDefault();
        e.stopPropagation();
      }
      
      isActive = false;
      clearTimeout(longPressTimer);
      clearInterval(repeatTimer);
      
      // Si ce n'était pas un appui long, faire l'action simple
      if (!hasLongPressed) {
        adjustLife(amount);
      }
      
      // Débloquer après un court délai
      setTimeout(() => {
        isProcessingRef.current = false;
        window.lastEventKey = null;
      }, 100);
      
      // Nettoyer les listeners
      document.removeEventListener('pointerup', stopInteraction);
      document.removeEventListener('pointercancel', stopInteraction);
      document.removeEventListener('touchend', stopInteraction);
      document.removeEventListener('touchcancel', stopInteraction);
      document.removeEventListener('mouseup', stopInteraction);
      document.removeEventListener('mouseleave', stopInteraction);
    };
    
    // Ajouter plusieurs types d'événements pour une meilleure compatibilité
    document.addEventListener('pointerup', stopInteraction);
    document.addEventListener('pointercancel', stopInteraction);
    document.addEventListener('touchend', stopInteraction);
    document.addEventListener('touchcancel', stopInteraction);
    document.addEventListener('mouseup', stopInteraction);
    document.addEventListener('mouseleave', stopInteraction);
  };

  return (
    <div 
      className="w-full flex flex-col items-center justify-center p-6 relative"
      style={{
        userSelect: 'none',
        WebkitUserSelect: 'none',
        MozUserSelect: 'none',
        msUserSelect: 'none',
        WebkitTouchCallout: 'none',
        touchAction: 'manipulation'
      }}
    >
      {/* Affichage du cumul amélioré */}
      {showCumul && displayCumul !== 0 && (
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
              onTouchStart={(e) => handleButtonInteraction(-1, e)}
              onMouseDown={(e) => handleButtonInteraction(-1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
              style={{ 
                userSelect: 'none', 
                touchAction: 'manipulation',
                WebkitTouchCallout: 'none',
                WebkitUserSelect: 'none',
                WebkitTapHighlightColor: 'transparent'
              }}
            >
              −
            </button>
            <div className="text-8xl font-bold mx-4 text-white">
              {pv || 0}
            </div>
            <button
              onPointerDown={(e) => handleButtonInteraction(1, e)}
              onTouchStart={(e) => handleButtonInteraction(1, e)}
              onMouseDown={(e) => handleButtonInteraction(1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
              style={{ 
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
              onTouchStart={(e) => handleButtonInteraction(1, e)}
              onMouseDown={(e) => handleButtonInteraction(1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
              style={{ 
                userSelect: 'none', 
                touchAction: 'manipulation',
                WebkitTouchCallout: 'none',
                WebkitUserSelect: 'none',
                WebkitTapHighlightColor: 'transparent'
              }}
            >
              +
            </button>
            <div className="text-8xl font-bold mx-4 text-white">
              {pv || 0}
            </div>
            <button
              onPointerDown={(e) => handleButtonInteraction(-1, e)}
              onTouchStart={(e) => handleButtonInteraction(-1, e)}
              onMouseDown={(e) => handleButtonInteraction(-1, e)}
              onContextMenu={(e) => e.preventDefault()}
              className="text-white hover:text-gray-200 active:text-gray-400 text-7xl font-black select-none transition-colors cursor-pointer"
              style={{ 
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