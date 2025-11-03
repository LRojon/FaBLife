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
    // Éviter les événements en double avec un système de verrouillage simple
    if (isProcessingRef.current) {
      console.log('Event ignored - already processing');
      return;
    }
    
    isProcessingRef.current = true;
    
    event.preventDefault();
    event.stopPropagation();
    
    let timeout;
    let interval;
    let hasLongPressed = false;
    let isActive = true;
    
    console.log('Button interaction started:', amount, 'Event type:', event.type); // Debug pour prod
    
    const startLongPress = () => {
      timeout = setTimeout(() => {
        if (!isActive) return;
        hasLongPressed = true;
        const longPressAmount = amount * 5;
        console.log('Long press started with amount:', longPressAmount); // Debug
        
        interval = setInterval(() => {
          if (!isActive) return;
          
          console.log('Long press tick:', longPressAmount); // Debug
          // Arrêter l'appui long si les PV ne changent plus
          const success = adjustLife(longPressAmount);
          if (!success) {
            console.log('Long press stopped - no more changes possible'); // Debug
            isActive = false;
            clearInterval(interval);
          }
        }, 400);
      }, 300);
    };

    const stopLongPress = () => {
      isActive = false;
      clearTimeout(timeout);
      clearInterval(interval);
      
      console.log('Long press stopped, hasLongPressed:', hasLongPressed); // Debug
      
      if (!hasLongPressed) {
        console.log('Short press, applying:', amount); // Debug
        adjustLife(amount);
      }
    };
    
    startLongPress();
    
    const cleanup = () => {
      console.log('Cleanup triggered'); // Debug
      stopLongPress();
      
      // Débloquer le traitement immédiatement
      isProcessingRef.current = false;
      console.log('Processing unlocked');
      
      // Nettoyer les event listeners
      window.removeEventListener('pointerup', cleanup, { passive: false });
      window.removeEventListener('pointercancel', cleanup, { passive: false });
      window.removeEventListener('contextmenu', cleanup, { passive: false });
    };
    
    // Utiliser seulement les événements pointer pour éviter les doublons
    window.addEventListener('pointerup', cleanup, { passive: false });
    window.addEventListener('pointercancel', cleanup, { passive: false });
    window.addEventListener('contextmenu', cleanup, { passive: false });
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