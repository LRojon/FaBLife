import React from 'react';
import { X } from 'lucide-react';

const StartingLifeModal = ({ player, format, onClose, onSelectLife }) => {
  const getLifeOptions = () => {
    if (format === 'adult') {
      return [40, 38, 36, 32, 30];
    } else {
      return [22, 21, 20, 19, 18, 17, 16, 15];
    }
  };

  const isPlayer2 = player === 'Joueur 2';
  
  // Position selon le joueur
  const positionClass = isPlayer2 ? 'items-start pt-8' : 'items-end pb-8';
  
  return (
    <div className={`fixed inset-0 bg-black bg-opacity-75 z-50 flex ${positionClass} justify-center p-4`}>
      <div className={`bg-gray-800 rounded-lg w-80 h-96 p-6 border-2 border-gray-600 transform -rotate-90 ${isPlayer2 ? 'origin-top-center' : 'origin-bottom-center'}`}>
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-lg font-bold">PV - {player}</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-white">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="grid grid-cols-2 gap-3">
          {getLifeOptions().map((life) => (
            <button
              key={life}
              onClick={() => onSelectLife(life)}
              className="bg-gradient-to-r from-red-600 to-red-700 hover:from-red-700 hover:to-red-800 text-white py-3 rounded-lg font-bold text-lg transition-all transform hover:scale-105"
            >
              {life} PV
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default StartingLifeModal;