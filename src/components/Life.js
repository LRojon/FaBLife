import React, { useState } from 'react';

const Life = ({ pv, cumul, onLifeChange, isPlayer1 }) => {

  const adjustLife = (amount) => {
    const newLife = Math.max(0, pv + amount);
    const actualChange = newLife - pv;
    
    // Seulement si les PV ont vraiment changé
    if (actualChange !== 0) {
      onLifeChange(actualChange);
    }
  };

  const handleButtonInteraction = (amount, event) => {
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
        const longPressAmount = amount * 5;
        
        interval = setInterval(() => {
          if (!isActive) return;
          adjustLife(longPressAmount);
        }, 150);
      }, 300);
    };

    const stopLongPress = () => {
      isActive = false;
      clearTimeout(timeout);
      clearInterval(interval);
      
      if (!hasLongPressed) {
        adjustLife(amount);
      }
    };
    
    startLongPress();
    
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
      {/* Affichage du cumul */}
      {cumul !== null && (
        <div 
          className={`absolute text-3xl font-bold ${
            cumul > 0 ? 'text-green-400' : 'text-red-400'
          }`}
          style={{
            top: '20%',
            left: '50%',
            transform: 'translateX(-50%)',
            textShadow: '2px 2px 4px rgba(0,0,0,0.8)',
            zIndex: 10
          }}
        >
          {cumul > 0 ? '+' : ''}{cumul}
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