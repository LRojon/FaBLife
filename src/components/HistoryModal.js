import React from 'react';
import { X, History } from 'lucide-react';

const HistoryModal = ({ history, onClose }) => {
  // Séparer l'historique par joueur
  const player1History = history.filter(entry => entry.action.includes('Joueur 1'));
  const player2History = history.filter(entry => entry.action.includes('Joueur 2'));
  const generalHistory = history.filter(entry => !entry.action.includes('Joueur'));

  return (
    <div className="fixed inset-0 bg-black bg-opacity-90 z-50 flex items-center justify-center p-4">
      <div className="bg-gray-800 rounded-lg w-full max-w-4xl h-[90vh] p-6 overflow-hidden">
        <div className="flex justify-between items-center mb-6">
          <h2 className="text-2xl font-bold flex items-center gap-2">
            <History className="w-6 h-6" />
            Historique
          </h2>
          <button onClick={onClose} className="text-gray-400 hover:text-white">
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Tableau orienté à 90° vers la droite */}
        <div className="transform rotate-90 origin-center w-full h-full">
          <div className="grid grid-cols-2 gap-4 h-full -translate-y-full">
            {/* Colonne Joueur 1 */}
            <div className="bg-gray-700 rounded-lg p-4 overflow-y-auto">
              <h3 className="text-lg font-semibold mb-4 text-center text-blue-400">Joueur 1</h3>
              <div className="space-y-2">
                {player1History.length === 0 ? (
                  <p className="text-gray-400 text-center text-sm">Aucune action</p>
                ) : (
                  player1History.slice().reverse().map((entry, index) => (
                    <div key={index} className="bg-gray-600 rounded p-2 text-sm">
                      {entry.action.replace('Joueur 1: ', '')}
                    </div>
                  ))
                )}
              </div>
            </div>

            {/* Colonne Joueur 2 */}
            <div className="bg-gray-700 rounded-lg p-4 overflow-y-auto">
              <h3 className="text-lg font-semibold mb-4 text-center text-red-400">Joueur 2</h3>
              <div className="space-y-2">
                {player2History.length === 0 ? (
                  <p className="text-gray-400 text-center text-sm">Aucune action</p>
                ) : (
                  player2History.slice().reverse().map((entry, index) => (
                    <div key={index} className="bg-gray-600 rounded p-2 text-sm">
                      {entry.action.replace('Joueur 2: ', '')}
                    </div>
                  ))
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Actions générales en bas */}
        {generalHistory.length > 0 && (
          <div className="absolute bottom-6 left-6 right-6">
            <div className="bg-gray-700 rounded-lg p-3">
              <h4 className="text-sm font-medium mb-2">Actions générales :</h4>
              <div className="flex flex-wrap gap-2">
                {generalHistory.slice().reverse().map((entry, index) => (
                  <span key={index} className="bg-gray-600 rounded px-2 py-1 text-xs">
                    {entry.action}
                  </span>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default HistoryModal;