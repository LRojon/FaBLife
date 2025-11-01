import React, { useState, useEffect } from 'react';
import HistoryModal from './components/HistoryModal';
import FormatSelectionModal from './components/FormatSelectionModal';
import StartingLifeModal from './components/StartingLifeModal';
import CentralMenu from './components/CentralMenu';
import PlayerLifeBlock from './components/PlayerLifeBlock';

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
    if (gameState) {
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
      setGameState(prev => ({
        ...prev,
        player2: { life: life, maxLife: life }
      }));
      setShowStartingLife(false);
      addToHistory(`Nouvelle partie ${selectedFormat === 'adult' ? 'Adulte' : 'Jeune'} commencée`);
    }
  };

  const updatePlayer1Life = (newLife) => {
    const oldLife = gameState.player1.life;
    const diff = newLife - oldLife;
    setGameState({
      ...gameState,
      player1: { ...gameState.player1, life: newLife }
    });
    addToHistory(`Joueur 1: ${diff > 0 ? '+' : ''}${diff} PV`);
  };

  const updatePlayer2Life = (newLife) => {
    const oldLife = gameState.player2.life;
    const diff = newLife - oldLife;
    setGameState({
      ...gameState,
      player2: { ...gameState.player2, life: newLife }
    });
    addToHistory(`Joueur 2: ${diff > 0 ? '+' : ''}${diff} PV`);
  };

  return (
    <div className="h-screen flex flex-col bg-gray-900 text-gray-100 overflow-hidden">
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
      
      {/* Player 2 (Top, rotated) */}
      <PlayerLifeBlock
        key={`player2-${gameState.player2.life}-${gameState.player2.maxLife}`}
        player={gameState.player2}
        onLifeChange={updatePlayer2Life}
        isTop={true}
      />

      {/* Middle Controls */}
      <CentralMenu 
        onReset={handleReset}
        onShowHistory={() => setShowHistory(true)}
      />

      {/* Player 1 (Bottom) */}
      <PlayerLifeBlock
        key={`player1-${gameState.player1.life}-${gameState.player1.maxLife}`}
        player={gameState.player1}
        onLifeChange={updatePlayer1Life}
        isTop={false}
      />
    </div>
  );
}