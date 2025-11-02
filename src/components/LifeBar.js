import React from 'react';

const LifeBar = ({ currentPV, maxPV, isTop }) => {
  const getLifeBarColor = () => {
    if (!currentPV || !maxPV) {
      return 'from-gray-500 via-gray-400 to-gray-500';
    }
    const percentage = (currentPV / maxPV) * 100;
    if (percentage > 60) return 'from-emerald-500 via-green-400 to-emerald-600';
    if (percentage > 30) return 'from-amber-500 via-yellow-400 to-orange-500';
    return 'from-red-500 via-red-400 to-red-600';
  };

  const lifePercentage = currentPV && maxPV ? (currentPV / maxPV) * 100 : 0;

  return (
    <div className="flex flex-col justify-center items-center w-full">
      {/* Barre horizontale qui prend toute la largeur - plus épaisse */}
      <div className="w-full h-8 bg-gradient-to-r from-gray-900 to-gray-800 border-2 border-gray-500 rounded-lg shadow-lg overflow-hidden relative">
        <div className="w-full h-full bg-gradient-to-r from-gray-800 to-gray-900 relative">
          {/* Barre de vie - direction selon le joueur */}
          <div 
            className={`h-full bg-gradient-to-r ${getLifeBarColor()} transition-all duration-700 ease-in-out absolute ${isTop ? 'right-0' : 'left-0'} shadow-inner`}
            style={{ 
              width: lifePercentage + '%',
              minWidth: currentPV > 0 ? '2px' : '0px',
              boxShadow: 'inset 0 1px 3px rgba(0,0,0,0.3), inset 0 -1px 0 rgba(255,255,255,0.1)'
            }}
          />
          <div 
            className={`h-full bg-gradient-to-r from-transparent via-white/30 to-transparent absolute ${isTop ? 'right-0' : 'left-0'} pointer-events-none transition-all duration-700 ease-in-out`}
            style={{ 
              width: lifePercentage + '%',
              minWidth: currentPV > 0 ? '2px' : '0px'
            }}
          />
          
          {/* Bordure interne pour effet de profondeur */}
          <div className="absolute inset-1 border border-white/10 rounded-md pointer-events-none"></div>
          
          {/* Petits segments pour l'effet "jauges" horizontaux */}
          {Array.from({ length: 9 }, (_, i) => (
            <div
              key={i}
              className="absolute h-full w-0.5 bg-gradient-to-b from-transparent via-gray-900/80 to-transparent shadow-sm"
              style={{ left: `${((i + 1) * 10)}%` }}
            />
          ))}
        </div>
      </div>
    </div>
  );
};

export default LifeBar;