import React, { useState, useEffect } from 'react';
import HistoryModal from './components/HistoryModal';
import FormatSelectionModal from './components/FormatSelectionModal';
import StartingLifeModal from './components/StartingLifeModal';
import CentralMenu from './components/CentralMenu';
import Player from './components/Player';

export default function FabLifeCounter() {
  const [showHistory, setShowHistory] = useState(false);
  const [showFormatSelection, setShowFormatSelection] = useState(false);
  const [showStartingLife, setShowStartingLife] = useState(false);
  const [selectedFormat, setSelectedFormat] = useState('adult');
  const [currentPlayer, setCurrentPlayer] = useState('');
  const [gameState, setGameState] = useState({
    format: 'adult',
    player1: { life: 40, maxLife: 40 },
    player2: { life: 40, maxLife: 40 },
    history: []
  });

  // Empêcher la mise en veille sur mobile
  useEffect(() => {
    let wakeLock = null;
    
    const requestWakeLock = async () => {
      try {
        if ('wakeLock' in navigator) {
          wakeLock = await navigator.wakeLock.request('screen');
          console.log('📱 Wake Lock activé');
        }
      } catch (err) {
        console.log('❌ Wake Lock non supporté:', err);
      }
    };

    // Demander le wake lock au chargement
    requestWakeLock();

    // Rétablir le wake lock quand l'utilisateur revient sur l'onglet
    const handleVisibilityChange = () => {
      if (wakeLock !== null && document.visibilityState === 'visible') {
        requestWakeLock();
      }
    };

    // Désactiver le menu contextuel globalement
    const handleContextMenu = (e) => {
      e.preventDefault();
      return false;
    };

    document.addEventListener('visibilitychange', handleVisibilityChange);
    document.addEventListener('contextmenu', handleContextMenu);

    return () => {
      document.removeEventListener('visibilitychange', handleVisibilityChange);
      document.removeEventListener('contextmenu', handleContextMenu);
      if (wakeLock) {
        wakeLock.release();
      }
    };
  }, []);

  // Empêcher la rotation sur mobile via CSS et événements
  useEffect(() => {
    const preventRotation = () => {
      if (window.screen && window.screen.orientation && window.screen.orientation.lock) {
        window.screen.orientation.lock('portrait').catch(err => {
          console.log('❌ Orientation lock non supporté:', err);
        });
      }
    };

    preventRotation();
  }, []);

  // Sauvegarde automatique
  const saveGameState = (state) => {
    if (state) {
      localStorage.setItem('fab-life-counter-state', JSON.stringify(state));
    }
  };

  // Chargement automatique
  useEffect(() => {
    const saved = localStorage.getItem('fab-life-counter-state');
    if (saved) {
      try {
        const parsed = JSON.parse(saved);
        // S'assurer que les nouvelles propriétés existent
        if (!parsed.history) {
          parsed.history = [];
        }
        setGameState(parsed);
      } catch (e) {
        console.error('Erreur lors du chargement de la sauvegarde:', e);
      }
    }
  }, []);

  // Sauvegarde automatique à chaque changement
  useEffect(() => {
    if (gameState && (gameState.player1.life !== 40 || gameState.player2.life !== 40)) {
      // Ne sauvegarder que si ce n'est pas l'état initial par défaut
      saveGameState(gameState);
    }
  }, [gameState]);

  const addToHistory = (action) => {
    const historyEntry = {
      action
    };
    
    setGameState(prev => ({
      ...prev,
      history: [...(prev.history || []), historyEntry]
    }));
  };

  const handleReset = () => {
    setShowFormatSelection(true);
  };

  const handleFormatSelection = (format) => {
    setSelectedFormat(format);
    setShowFormatSelection(false);
    setCurrentPlayer('Joueur 1');
    setShowStartingLife(true);
  };

  const handleStartingLifeSelection = (life) => {
    if (currentPlayer === 'Joueur 1') {
      setGameState(prev => ({
        ...prev,
        format: selectedFormat,
        player1: { life: life, maxLife: life }
      }));
      setCurrentPlayer('Joueur 2');
    } else {
      const historyEntry = {
        action: `Nouvelle partie ${selectedFormat === 'adult' ? 'Adulte' : 'Jeune'} commencée`
      };
      
      const newState = {
        format: selectedFormat,
        player1: { life: gameState.player1.life, maxLife: gameState.player1.maxLife },
        player2: { life: life, maxLife: life },
        history: [historyEntry] // Reset de l'historique avec seulement l'entrée de nouvelle partie
      };
      
      setGameState(newState);
      setShowStartingLife(false);
      
      // Forcer la sauvegarde immédiate du nouvel état
      setTimeout(() => {
        saveGameState(newState);
      }, 100);
    }
  };

  // Fonction unifiée pour les changements de vie
  const updatePlayerLife = (playerNumber, newLife) => {
    const playerKey = `player${playerNumber}`;
    const oldLife = gameState[playerKey].life;
    const diff = newLife - oldLife;
    const historyEntry = {
      action: `Joueur ${playerNumber}: ${diff > 0 ? '+' : ''}${diff} PV`
    };
    
    setGameState(prev => ({
      ...prev,
      [playerKey]: { ...prev[playerKey], life: newLife },
      history: [...(prev.history || []), historyEntry]
    }));
  };

  const updatePlayer1Life = (newLife) => updatePlayerLife(1, newLife);
  const updatePlayer2Life = (newLife) => updatePlayerLife(2, newLife);

  return (
    <div 
      className="h-screen w-full flex flex-col bg-gray-900 text-gray-100 overflow-hidden md:flex-row md:flex-wrap md:content-between"
      onContextMenu={(e) => e.preventDefault()}
      style={{
        userSelect: 'none',
        WebkitUserSelect: 'none',
        MozUserSelect: 'none',
        msUserSelect: 'none',
        WebkitTouchCallout: 'none'
      }}
    >
      {showHistory && (
        <HistoryModal
          history={gameState.history || []}
          onClose={() => setShowHistory(false)}
        />
      )}

      {showFormatSelection && (
        <FormatSelectionModal
          onClose={() => setShowFormatSelection(false)}
          onSelectFormat={handleFormatSelection}
        />
      )}

      {showStartingLife && (
        <StartingLifeModal
          player={currentPlayer}
          format={selectedFormat}
          onClose={() => setShowStartingLife(false)}
          onSelectLife={handleStartingLifeSelection}
        />
      )}
      
      {/* Player 2 (Top on mobile, Right on desktop) */}
      <Player
        isPlayer1={false}
        initialLife={gameState.player2.life}
        maxLife={gameState.player2.maxLife}
      />

      {/* Middle Controls */}
      <CentralMenu 
        onReset={handleReset}
        onShowHistory={() => setShowHistory(true)}
      />

      {/* Player 1 (Bottom on mobile, Left on desktop) */}
      <Player
        isPlayer1={true}
        initialLife={gameState.player1.life}
        maxLife={gameState.player1.maxLife}
      />
    </div>
  );
}