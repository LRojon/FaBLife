import React, { useState, useEffect } from 'react';
import LifeBar from './LifeBar';
import Life from './Life';

const Player = ({ isPlayer1, initialLife = 20, maxLife = 20, gameId = 0 }) => {
  const [currentPV, setCurrentPV] = useState(initialLife);
  const [cumul, setCumul] = useState(null);

  const rotationClass = isPlayer1 ? '-rotate-90' : '-rotate-90';

  // Mettre à jour les PV si initialLife change (lors du reset via App.js)
  useEffect(() => {
    setCurrentPV(initialLife);
  }, [initialLife, maxLife, gameId]);

  const handleLifeChange = (change) => {
    const newLife = Math.max(0, currentPV + change);
    setCurrentPV(newLife);
    
    // Afficher le cumul
    setCumul(change);
    
    // Masquer le cumul après 300ms
    setTimeout(() => {
      setCumul(null);
    }, 300);
  };

  return (
    <div 
      className={`flex-1 flex bg-gray-800 relative ${rotationClass} md:rotate-0 md:flex-col md:w-1/2 md:h-full md:border-x md:border-gray-700 ${isPlayer1 ? 'order-3 md:order-1' : 'order-1 md:order-2'}`}
      style={{
        userSelect: 'none',
        WebkitUserSelect: 'none',
        MozUserSelect: 'none',
        msUserSelect: 'none',
        WebkitTouchCallout: 'none',
        touchAction: 'manipulation'
      }}
    >
      {/* Barre de PV en haut qui prend toute la largeur */}
      <div className="absolute top-4 left-4 right-4 z-20 md:static md:w-full md:px-4 md:pt-4">
        <LifeBar 
          currentPV={currentPV} 
          maxPV={maxLife} 
          isTop={!isPlayer1} 
        />
      </div>
      
      <Life 
        pv={currentPV}
        cumul={cumul}
        onLifeChange={handleLifeChange}
        isPlayer1={isPlayer1}
      />
    </div>
  );
};

export default Player;