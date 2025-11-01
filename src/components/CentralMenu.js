import React, { useState, useEffect } from 'react';
import { RotateCcw, History, Maximize, Minimize } from 'lucide-react';

const CentralMenu = ({ onReset, onShowHistory }) => {
  const [isFullscreen, setIsFullscreen] = useState(false);

  // Détecter les changements de plein écran
  useEffect(() => {
    const handleFullscreenChange = () => {
      setIsFullscreen(!!document.fullscreenElement);
    };

    document.addEventListener('fullscreenchange', handleFullscreenChange);
    return () => document.removeEventListener('fullscreenchange', handleFullscreenChange);
  }, []);

  // Fonction pour basculer le plein écran
  const toggleFullscreen = async () => {
    try {
      if (!document.fullscreenElement) {
        await document.documentElement.requestFullscreen();
      } else {
        await document.exitFullscreen();
      }
    } catch (error) {
      console.error('Erreur lors du basculement plein écran:', error);
    }
  };
  return (
    <div className="bg-gray-900 border-y border-gray-700 flex items-center justify-center gap-2 py-2 px-4">
      <button
        onClick={onShowHistory}
        className="bg-gray-700 hover:bg-gray-600 text-white rounded-lg px-4 py-2 flex items-center gap-2 text-sm font-semibold hidden"
      >
        <History className="w-4 h-4" />
        Historique
      </button>

      <button
        onClick={toggleFullscreen}
        className="bg-blue-600 hover:bg-blue-700 text-white rounded-lg p-2 flex items-center justify-center"
        title={isFullscreen ? "Quitter le plein écran" : "Plein écran"}
      >
        {isFullscreen ? <Minimize className="w-4 h-4" /> : <Maximize className="w-4 h-4" />}
      </button>

      <button
        onClick={onReset}
        className="bg-red-600 hover:bg-red-700 text-white rounded-lg px-4 py-2 flex items-center gap-2 text-sm font-semibold"
      >
        <RotateCcw className="w-4 h-4" />
        Reset
      </button>
    </div>
  );
};

export default CentralMenu;