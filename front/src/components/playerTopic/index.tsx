import React from 'react';

import { ChessPiece } from "./styles";

export default function PlayerTopic(props: any) {

  return (
    <ChessPiece role="img">
      ♘ {props.children}
    </ChessPiece>
  );
};
