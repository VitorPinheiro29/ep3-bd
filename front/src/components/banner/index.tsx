import React, { useEffect, useState } from "react";

import bestPlace from "../../images/best_place.svg";

import {
  BannerContainer,
  BannerImage,
  BannerApresentation,
  ApresentationTitle,
  ApresentationDescription,
} from "./styles";

export default function Banner() {
    return(
        <BannerContainer>
        <BannerApresentation>
          <ApresentationTitle>Sampa Chess</ApresentationTitle>
          <ApresentationDescription>
            Confira a programação e os detalhes do maior campeonato
            internacional de xadrez do Brasil
          </ApresentationDescription>
        </BannerApresentation>
        <BannerImage>
          <img src={bestPlace} />
        </BannerImage>
      </BannerContainer>
    )
}
